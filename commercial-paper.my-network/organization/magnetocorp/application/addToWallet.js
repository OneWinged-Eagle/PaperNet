/*
 *  SPDX-License-Identifier: Apache-2.0
 */

'use strict';

// Bring key classes into scope, most importantly Fabric SDK network class
const fs = require('fs');
const { FileSystemWallet, X509WalletMixin } = require('fabric-network');
const path = require('path');

const fixtures = path.resolve(__dirname, '../../../../my-network');

// A wallet stores a collection of identities
const wallet = new FileSystemWallet('../identity/user/isabella/wallet');

async function main() {

	// Main try/catch block
	try {

		// Identity to credentials to be stored in the wallet
		const credPath = path.join(fixtures, '/crypto-config/peerOrganizations/magnetocorp.example.com/users/User1@magnetocorp.example.com');
		const cert = fs.readFileSync(path.join(credPath, '/msp/signcerts/User1@magnetocorp.example.com-cert.pem')).toString();
		const key = fs.readFileSync(path.join(credPath, '/msp/keystore/5dee756f15868d0df19eeb0e3f1dcfe07e90f1f44c0a4ccf0307d09960614a8d_sk')).toString();

		// Load credentials into wallet
		const identityLabel = 'User1@magnetocorp.example.com';
		const identity = X509WalletMixin.createIdentity('MagnetoCorpMSP', cert, key);

		await wallet.import(identityLabel, identity);

	} catch (error) {
		console.log(`Error adding to wallet. ${error}`);
		console.log(error.stack);
	}
}

main().then(() => {
	console.log('done');
}).catch((e) => {
	console.log(e);
	console.log(e.stack);
	process.exit(-1);
});
