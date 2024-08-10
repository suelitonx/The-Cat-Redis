import Router from 'express';
import { AutenticacionController, verifyToken } from '../controllers/authentication.controller';
import { FavoritosController } from '../controllers/favoritos.controller';

const router = Router();

// Rota inicial
router.get('/', (req, res) => {
    res.send({
        "data": "API DO PROJETO DE BD2 [UTILIZANDO REDIS]"
    });
});

//Validar token
router.get('/validar', verifyToken, AutenticacionController.validarToken);

//Favoritos
router.get('/favoritos', verifyToken, FavoritosController.getFavoritos); // Rota protegida
router.post('/addfavoritos', verifyToken, FavoritosController.addFavorito); // Rota protegida
router.delete('/favoritos', verifyToken, FavoritosController.removeFavorito); // Rota protegida

//Autenticação
router.post('/login', AutenticacionController.login);
router.post('/signup', AutenticacionController.signup);

export { router };