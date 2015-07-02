var braintree = require('braintree');
var gateway = braintree.connect({
                                environment:  braintree.Environment.Sandbox,
                                merchantId:   'h63bz4tvj9nssm9b',
                                publicKey:    'tdmgh5nffkbn94jz',
                                privateKey:   '47f429f1e73b2e50f19c6277f9cd2f84'
                                });

var express = require('express');
var app = express();
app.listen(9999);

app.get('/', function(req, res){ res.send("Hello world!"); });

app.get('/client_token', function(req, res){
        gateway.clientToken.generate({ customerId: createCustomer(req.query.cid) },
                                    function (err, response) {
                                        console.log('ERROR: '+err+'\nclient token :'+response.clientToken);
                                        res.send(response.clientToken);
                                     });
});

app.get('/payment_methods', function(req, res){
        var nonce = req.query.payment_method_nonce;
        var amount_client = req.query.amount;
        gateway.transaction.sale({ amount: amount_client, paymentMethodNonce: nonce },
                                 function (err, result) {
                                    console.log(nonce + " nonce for $" + amount_client);
                                    res.send(result);
                                 });
        });

function createCustomer(customerId) {
    gateway.customer.create({
                            firstName: "Jen",
                            lastName: "Smith",
                            company: "Braintree",
                            email: "jen@example.com",
                            phone: "312.555.1234",
                            fax: "614.555.5678",
                            website: "www.example.com"
                            }, function (err, result) {
                            result.success;
                            // true
                            
                            return result.customer.id;
                            // e.g. 494019
                            });
}
