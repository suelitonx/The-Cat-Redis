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
Object.defineProperty(exports, "__esModule", { value: true });
exports.FavoritosController = void 0;
const redis_1 = require("redis");
class FavoritosController {
    static teste(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            const redisClient = yield (0, redis_1.createClient)().on('error', _ => res.status(400).send({ message: 'Servidor caiu.' })).connect();
            const res1 = yield redisClient.hSet('bike:1', {
                'model': 'Deimos',
                'brand': 'Ergonom',
                'type': 'Enduro bikes',
                'price': 4972,
            });
            const res2 = yield redisClient.hSet('bike:2', {
                'model': 'Deimos',
                'brand': 'Ergonom',
                'type': 'Enduro bikes',
                'price': 4972,
            });
            const res3 = yield redisClient.hSet('bike:3', {
                'model': 'Deimos',
                'brand': 'Ergonom',
                'type': 'Enduro bikes',
                'price': 4972,
            });
            //Enviar resposta
            res.send({ res1, res2, res3 });
            yield redisClient.disconnect();
        });
    }
    static getFavoritos(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            let { useremail } = req.body;
            const key = `${useremail}:favoritos`;
            const redisClient = yield (0, redis_1.createClient)().on('error', err => console.log('Erro no cliente REDIS.', err)).connect();
            try {
                const favoritos = yield redisClient.lRange(key, 0, -1);
                yield redisClient.disconnect();
                res.send(favoritos);
            }
            catch (error) {
                //Erro
                console.log('Erro ao buscar favoritos.', error);
                yield redisClient.disconnect();
                res.status(500).send({ message: 'Erro ao buscar favoritos.' });
            }
        });
    }
    static addFavorito(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            let { useremail, favorito } = req.body;
            const key = `${useremail}:favoritos`;
            console.log(req.body);
            const redisClient = yield (0, redis_1.createClient)().on('error', err => console.log('Erro no cliente REDIS.', err)).connect();
            try {
                yield redisClient.rPush(key, favorito);
            }
            catch (error) {
                //Erro
                console.log('Erro ao adicionar favorito.', error);
                yield redisClient.disconnect();
                res.status(500).send({ message: 'Erro ao adicionar favorito.' });
            }
            yield redisClient.disconnect();
            res.send({ message: 'Favorito adicionado com sucesso.' });
        });
    }
    static removeFavorito(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            //Remover favorito
            let { useremail, favorito } = req.body;
            const key = `${useremail}:favoritos`;
            const redisClient = yield (0, redis_1.createClient)().on('error', err => console.log('Erro no cliente REDIS.', err)).connect();
            try {
                yield redisClient.lRem(key, 0, favorito);
            }
            catch (error) {
                //Erro
                console.log('Erro ao remover favorito.', error);
                yield redisClient.disconnect();
                res.status(500).send({ message: 'Erro ao remover favorito.' });
            }
            yield redisClient.disconnect();
            res.send({ message: 'Favorito removido com sucesso.' });
        });
    }
}
exports.FavoritosController = FavoritosController;
