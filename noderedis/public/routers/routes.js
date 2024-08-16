"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.router = void 0;
const express_1 = __importDefault(require("express"));
const authentication_controller_1 = require("../controllers/authentication.controller");
const favoritos_controller_1 = require("../controllers/favoritos.controller");
const router = (0, express_1.default)();
exports.router = router;
// Rota inicial
router.get('/', (req, res) => {
    res.send({
        "data": "API DO PROJETO DE BD2 [UTILIZANDO REDIS]"
    });
});
//Validar token
router.get('/validar', authentication_controller_1.verifyToken, authentication_controller_1.AutenticacionController.validarToken);
//Favoritos
router.get('/teste', favoritos_controller_1.FavoritosController.teste); // Rota protegida
router.get('/favoritos', authentication_controller_1.verifyToken, favoritos_controller_1.FavoritosController.getFavoritos); // Rota protegida
router.post('/addfavoritos', authentication_controller_1.verifyToken, favoritos_controller_1.FavoritosController.addFavorito); // Rota protegida
router.delete('/favoritos', authentication_controller_1.verifyToken, favoritos_controller_1.FavoritosController.removeFavorito); // Rota protegida
//Autenticação
router.post('/login', authentication_controller_1.AutenticacionController.login);
router.post('/signup', authentication_controller_1.AutenticacionController.signup);
