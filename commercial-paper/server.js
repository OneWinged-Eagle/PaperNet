const express = require("express")
const redeem = require("./organization/digibank/application/redeem")

const app = express()
const port = 3000

app.get("/", (_req, res) => res.status(200).send("Hello World!"))

app.get("/redeem", (_req, res) => {
	redeem().then(() => {
		res.send("Redeem program complete.")
	}).catch((err) => {
		res.send("Redeem program exception: ${err}")
	})
})

app.listen(port, () => console.info(`Example app listening on port ${port}!`))
