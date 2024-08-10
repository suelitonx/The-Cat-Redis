import express from "express"
import cors from "cors"
import { router } from "./routers/routes"

//Porta do servidor
const porta = 5000 || process.env.PORT

//Criando o servidor
const app = express()
app.use(cors())
app.use (express.json())
app.use(express.urlencoded({ extended: false }))
app.set("port", porta)

//Rotas
app.use("/", router);

//Iniciando o servidor
app.listen(app.get("port"), () => {
  console.log("Servidor está rodando na porta:", porta)
})