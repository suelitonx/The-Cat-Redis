"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const routes_1 = require("./routers/routes");
//Porta do servidor
const porta = 6000 || process.env.PORT;
//Criando o servidor
const app = (0, express_1.default)();
app.use((0, cors_1.default)());
app.use(express_1.default.json());
app.use(express_1.default.urlencoded({ extended: false }));
app.set("port", porta);
//Rotas
app.use("/", routes_1.router);
//Iniciando o servidor
app.listen(app.get("port"), () => {
    console.log("Servidor está rodando na porta:", porta);
});
