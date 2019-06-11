const express = require("express")
const issue = require("./organization/magnetocorp/application/issue")
const buy = require("./organization/digibank/application/buy")
const redeem = require("./organization/digibank/application/redeem")

const app = express()
const port = 3000

app.get("/", (_req, res) => res.status(200).send("Hello World!"))

app.get("/issue", (_req, res) => {
	issue().then(() => {
		res.send("Issue program complete.")
	}).catch((err) => {
		res.send(`Issue program exception: ${err}`)
	})
})

app.get("/buy", (_req, res) => {
	buy().then(() => {
		res.send("Buy program complete.")
	}).catch((err) => {
		res.send(`Buy program exception: ${err}`)
	})
})

app.get("/redeem", (_req, res) => {
	redeem().then(() => {
		res.send("Redeem program complete.")
	}).catch((err) => {
		res.send(`Redeem program exception: ${err}`)
	})
})

app.listen(port, () => console.info(`Example app listening on port ${port}!`))
