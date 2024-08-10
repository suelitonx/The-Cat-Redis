import { Request, Response } from 'express';
import { createClient } from 'redis';

export class FavoritosController {
    static async getFavoritos(req: Request, res: Response) {
        
        let { useremail } = req.body;

        const key = `${useremail}:favoritos`;

        const redisClient = await createClient().on('error', err => console.log('Erro no cliente REDIS.', err)).connect();

        try {
            const favoritos = await redisClient.lRange(key, 0, -1);
            await redisClient.disconnect();
            res.send(favoritos);
        } catch (error) {
            //Erro
            console.log('Erro ao buscar favoritos.', error);
            await redisClient.disconnect();
            res.status(500).send({ message: 'Erro ao buscar favoritos.' });
        }
    
    }

    static async addFavorito(req: Request, res: Response) {

        let { useremail, favorito } = req.body;

        const key = `${useremail}:favoritos`;

        console.log(req.body);
        
        const redisClient = await createClient().on('error', err => console.log('Erro no cliente REDIS.', err)).connect();

        try {
            await redisClient.rPush(key, favorito);
        } catch (error) {
            //Erro
            console.log('Erro ao adicionar favorito.', error);
            await redisClient.disconnect();
            res.status(500).send({ message: 'Erro ao adicionar favorito.' });
        }
        
        await redisClient.disconnect();

        res.send({ message: 'Favorito adicionado com sucesso.' });
    }

    static async removeFavorito(req: Request, res: Response) {
        //Remover favorito
        let { useremail, favorito } = req.body;

        const key = `${useremail}:favoritos`;

        const redisClient = await createClient().on('error', err => console.log('Erro no cliente REDIS.', err)).connect();

        try {
            await redisClient.lRem(key, 0, favorito);
        } catch (error) {
            //Erro
            console.log('Erro ao remover favorito.', error);
            await redisClient.disconnect();
            res.status(500).send({ message: 'Erro ao remover favorito.' });
        }

        await redisClient.disconnect();

        res.send({ message: 'Favorito removido com sucesso.' });
    }

}