import { NextFunction, Request, Response } from 'express';
import { createClient } from 'redis';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';

const JWT_SECRET = "TACIAN0LINDO";  // SECRET DO JWT

async function saveUserToRedis(useremail: string, userpassword: string) {
    // Criando um cliente do Redis
    const redisClient = await createClient().on('error', err => console.log('Erro no cliente REDIS.', err)).connect();
    
    // Hashing da senha
    const hashedPassword = await bcrypt.hash(userpassword, 10);
    
    // Salvando os dados no Redis
    const userData = JSON.stringify({ useremail, userpassword: hashedPassword });
    await redisClient.set(useremail, userData);
    
    // Fechando a conexão com o Redis
    await redisClient.disconnect();
}

// Função para verificar senha
async function verifyPassword(storedPassword: string, providedPassword: string) {
    return bcrypt.compare(providedPassword, storedPassword);
}

// Função para gerar JWT
function generateJWT(useremail: string) {
    return jwt.sign({ useremail }, JWT_SECRET, { expiresIn: '2h' });
}

export class AutenticacionController {

    //validar token
    static async validarToken(req: Request, res: Response) {
        if (req.body.useremail) {
            res.send({ message: 'Token válido.', authenticated: true });
        } else {
            res.status(400).send({ message: 'ERRO: Token inválido.', authenticated: false });
        }
    }

    static async signup(req: Request, res: Response) {
        let { useremail, userpassword } = req.body;

        // Criando um cliente do Redis
        const redisClient = await createClient().on('error', err => console.log('Erro no cliente REDIS.', err)).connect();

        const userDataString = await redisClient.get(useremail);

        // Verificando se o usuário já existe
        if (userDataString) {
            await redisClient.disconnect();
            return res.status(404).send({ message: 'ERRO: Usuário já existe.', signed: false });
        }

        // Salvando os dados no Redis
        await saveUserToRedis(useremail, userpassword);

        const token = generateJWT(useremail);

        // Retornando a resposta
        res.status(200).send({
            signed: true,
            useremail: useremail,
            userpassword: userpassword,
            token,
            message: 'Usuário cadastrado com sucesso.'
        });

        // Fechando a conexão com o Redis
        await redisClient.disconnect();
    }

    static async login(req: Request, res: Response) {
        let { useremail, newpassword } = req.body;

        if (!useremail || !newpassword) {
            return res.status(400).send({ message: 'ERRO: Credenciais inválidas.', authenticated: false });
        }

        // Criando um cliente do Redis
        const redisClient = await createClient().on('error', err => console.log('Erro no cliente REDIS.', err)).connect();

        // Pegando os dados do Redis
        const userDataString = await redisClient.get(useremail);

        // Se o usuário não for encontrado
        if (!userDataString) {
            await redisClient.disconnect();
            return res.status(404).send({authenticated: false, message: 'ERRO: Usuário não encontrado.' });
        }

        const userData = JSON.parse(userDataString);

        let oldpassword = userData.userpassword;
        let oldemail = userData.useremail;

        //Comparando senhas
        const passwordMatch = await verifyPassword(oldpassword, newpassword);
        
        if (oldemail === useremail && passwordMatch) {
            const token = generateJWT(useremail);

            res.status(200).send({authenticated: true, message: 'Login efetuado com sucesso', token });
        }
        else {
            res.status(400).send({authenticated: false, message: 'ERRO: Credenciais inválidas.' });
        }

        // Fechando a conexão com o Redis
        await redisClient.disconnect();
    }
}



export function verifyToken(req: Request, res: Response, next: NextFunction) {
    const token = req.headers['authorization'];

    if (!token) {
        return res.status(403).send({ error: 'Nenhum token enviado na requisição.' });
    }

    jwt.verify(token, JWT_SECRET, (err, decoded) => {
        if (err) {
            console.log(err);
            return res.status(401).send({ error: 'ERRO: Token inválido.' });
        }

        //Caso "decoded" não seja definido, retornamos um erro
        if (typeof decoded === 'string' || !decoded) {
            console.log("decoded: ", decoded);
            return res.status(402).send({ error: 'ERRO: Token inválido.' });
        }

        // Se o token for válido, armazenamos as informações do usuário na requesição
        
        if (typeof decoded !== 'string' && decoded!.useremail) {
            req.body.useremail = decoded!.useremail;
            next();
        } else {
            return res.status(401).send({ error: 'ERRO: Token inválido.' });
        }
        
    });
}
