import { Request, Response } from 'express';
import { createClient } from 'redis';

export class FavoritosController {
    
    static async teste(req: Request, res: Response) {

        const redisClient = await createClient({url: 'redis://:@TurmaBD2024mulest@127.0.0.1:6379'}).on('error', _ => res.status(400).send({ message: 'Servidor caiu.' })).connect();


        const res1 = await redisClient.hSet(
            'bike:1',
            {
              'model': 'Deimos',
              'brand': 'Ergonom',
              'type': 'Enduro bikes',
              'price': 4972,
            }
        );

        const res2 = await redisClient.hSet(
            'bike:2',
            {
              'model': 'Deimos',
              'brand': 'Ergonom',
              'type': 'Enduro bikes',
              'price': 4972,
            }
        );

        const res3 = await redisClient.hSet(
            'bike:3',
            {
              'model': 'Deimos',
              'brand': 'Ergonom',
              'type': 'Enduro bikes',
              'price': 4972,
            }
        );

        //Enviar resposta
        res.send({ res1, res2, res3 });

        await redisClient.disconnect();
    
    }

    static async testeget(req: Request, res: Response) {

        /*
        {
  host: '127.0.0.1',
  port: 6379,
  password: '@TurmaBD2024mulest'
}
        */
        const redisClient = await createClient({url: 'redis://:@TurmaBD2024mulest@127.0.0.1:6379'}).on('error', _ => res.status(400).send({ message: 'Servidor caiu.' })).connect();

        const res1 = await redisClient.hSet(
            'bike:1',
            {
              'model': 'Deimos',
              'brand': 'Ergonom',
              'type': 'Enduro bikes',
              'price': 4972,
            }
        );

        const res4 = await redisClient.hGetAll('bike:1')

        //Enviar resposta
        res.send( res4 );

        await redisClient.disconnect();
    
    }

    static async getFavoritos(req: Request, res: Response) {
        
        let { useremail } = req.body;

        const key = `${useremail}:favoritos`;

        const redisClient = await createClient({url: 'redis://:@TurmaBD2024mulest@127.0.0.1:6379'}).on('error', err => console.log('Erro no cliente REDIS.', err)).connect();

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
        
        const redisClient = await createClient({url: 'redis://:@TurmaBD2024mulest@127.0.0.1:6379'}).on('error', err => console.log('Erro no cliente REDIS.', err)).connect();

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

        const redisClient = await createClient({url: 'redis://:@TurmaBD2024mulest@127.0.0.1:6379'}).on('error', err => console.log('Erro no cliente REDIS.', err)).connect();

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