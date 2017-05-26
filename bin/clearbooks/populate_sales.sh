#!/bin/bash
npm run emptydb

TOKEN='Authorization: JWT eyJjFX4'
API='http://localhost:8095/micro-accounting/sales'

function create
{
	echo CREATE invoice $DATA
#	DATA='salesinvoice={"details":"$details","grossAmount":"$amount","invoiceDate":"$date"}'
	curl "$API" -H "$TOKEN" -d "$DATA"
}

DATA='salesinvoice={"grossAmount":"75.67","invoiceDate":"2017-02-28T00:00:00","details":"S0: Gunnery Frigates Opportunistic Continua Gide Motivation","vatAmount":0}'; create
DATA='salesinvoice={"grossAmount":"278.37","invoiceDate":"2017-03-25T00:00:00","details":"S1: Promenaded Institution’s Exponentially","vatAmount":0}'; create
