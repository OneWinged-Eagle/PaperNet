#!/usr/bin/env node

const express = require("express")
const path = require("path");

const issue = require("./organization/magnetocorp/application/issue")
const buy = require("./organization/digibank/application/buy")
const redeem = require("./organization/digibank/application/redeem")

const port = 3000

const app = express()
app.use(express.json())
app.use(express.urlencoded())

app.get("/", (_req, res) => {
	res.sendFile(path.resolve(__dirname, './index.html'))
})

app.post("/issue", (req, res) => {
	issue(req.body.paperNumber).then(() => {
		res.send("Issue program complete.")
	}).catch((err) => {
		res.send(`Issue program exception: ${err}`)
	})
})

app.post("/buy", (req, res) => {
	buy(req.body.paperNumber).then(() => {
		res.send("Buy program complete.")
	}).catch((err) => {
		res.send(`Buy program exception: ${err}`)
	})
})

app.post("/redeem", (req, res) => {
	redeem(req.body.paperNumber).then(() => {
		res.send("Redeem program complete.")
	}).catch((err) => {
		res.send(`Redeem program exception: ${err}`)
	})
})

app.listen(port, () => console.info(`Example app listening on port ${port}!`))
