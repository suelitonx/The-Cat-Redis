"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AutenticacionController = void 0;
exports.verifyToken = verifyToken;
const redis_1 = require("redis");
const bcrypt_1 = __importDefault(require("bcrypt"));
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const JWT_SECRET = "TACIAN0LINDO"; // SECRET DO JWT
function saveUserToRedis(useremail, userpassword) {
    return __awaiter(this, void 0, void 0, function* () {
        // Criando um cliente do Redis
        const redisClient = yield (0, redis_1.createClient)().on('error', err => console.log('Erro no cliente REDIS.', err)).connect();
        // Hashing da senha
        const hashedPassword = yield bcrypt_1.default.hash(userpassword, 10);
        // Salvando os dados no Redis
        const userData = JSON.stringify({ useremail, userpassword: hashedPassword });
        yield redisClient.set(useremail, userData);
        // Fechando a conexão com o Redis
        yield redisClient.disconnect();
    });
}
// Função para verificar senha
function verifyPassword(storedPassword, providedPassword) {
    return __awaiter(this, void 0, void 0, function* () {
        return bcrypt_1.default.compare(providedPassword, storedPassword);
    });
}
// Função para gerar JWT
function generateJWT(useremail) {
    return jsonwebtoken_1.default.sign({ useremail }, JWT_SECRET, { expiresIn: '2h' });
}
class AutenticacionController {
    //validar token
    static validarToken(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            if (req.body.useremail) {
                res.send({ message: 'Token válido.', authenticated: true });
            }
            else {
                res.status(400).send({ message: 'ERRO: Token inválido.', authenticated: false });
            }
        });
    }
    static signup(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            let { useremail, userpassword } = req.body;
            // Criando um cliente do Redis
            const redisClient = yield (0, redis_1.createClient)().on('error', err => console.log('Erro no cliente REDIS.', err)).connect();
            const userDataString = yield redisClient.get(useremail);
            // Verificando se o usuário já existe
            if (userDataString) {
                yield redisClient.disconnect();
                return res.status(404).send({ message: 'ERRO: Usuário já existe.', signed: false });
            }
            // Salvando os dados no Redis
            yield saveUserToRedis(useremail, userpassword);
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
            yield redisClient.disconnect();
        });
    }
    static login(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            let { useremail, newpassword } = req.body;
            if (!useremail || !newpassword) {
                return res.status(400).send({ message: 'ERRO: Credenciais inválidas.', authenticated: false });
            }
            // Criando um cliente do Redis
            const redisClient = yield (0, redis_1.createClient)().on('error', err => console.log('Erro no cliente REDIS.', err)).connect();
            // Pegando os dados do Redis
            const userDataString = yield redisClient.get(useremail);
            // Se o usuário não for encontrado
            if (!userDataString) {
                yield redisClient.disconnect();
                return res.status(404).send({ authenticated: false, message: 'ERRO: Usuário não encontrado.' });
            }
            const userData = JSON.parse(userDataString);
            let oldpassword = userData.userpassword;
            let oldemail = userData.useremail;
            //Comparando senhas
            const passwordMatch = yield verifyPassword(oldpassword, newpassword);
            if (oldemail === useremail && passwordMatch) {
                const token = generateJWT(useremail);
                res.status(200).send({ authenticated: true, message: 'Login efetuado com sucesso', token });
            }
            else {
                res.status(400).send({ authenticated: false, message: 'ERRO: Credenciais inválidas.' });
            }
            // Fechando a conexão com o Redis
            yield redisClient.disconnect();
        });
    }
}
exports.AutenticacionController = AutenticacionController;
function verifyToken(req, res, next) {
    const token = req.headers['authorization'];
    if (!token) {
        return res.status(403).send({ error: 'Nenhum token enviado na requisição.' });
    }
    jsonwebtoken_1.default.verify(token, JWT_SECRET, (err, decoded) => {
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
        if (typeof decoded !== 'string' && decoded.useremail) {
            req.body.useremail = decoded.useremail;
            next();
        }
        else {
            return res.status(401).send({ error: 'ERRO: Token inválido.' });
        }
    });
}
