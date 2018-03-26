

  var contractFunction;
  var contractAddress = "0xeb12de6f87eb9984f6130406b92b1bd4c3b99e6e";
  var contractFunction = web3.eth.contract(ABIArray).at(contractAddress); 
  
  function buy_product(row_id) {
      var supplier=$("#supplier"+row_id).val();
      var amount=$("#amount"+row_id).val();
      contractFunction.transfer(supplier,amount, {from: web3.eth.coinbase}, function(req, res) {
        console.log('Transaction ID:'+res);
      })
  }

  
  function get_transaction_nos() {
     var daySelect = document.getElementById("transaction_no");
      var myOption = document.createElement("option");
      myOption.text = "";
      myOption.value = ""
      daySelect.add(myOption);
    contractFunction.get_transaction_count(function(error, result) {
      for(i=1;i<=result;i++)
      {


      var myOption = document.createElement("option");
      myOption.text = i;
      myOption.value = i;
      daySelect.add(myOption);
       }
    });
  }
  function get_transaction_details(transaction_no)
  {
     contractFunction.get_transaction_details(transaction_no,function(error, result) {
        //alert(result);
        //result = result.split(",");
        html_header="<table>";
        html_content="<tr><td>Header</td><td>Details</td></tr> \
        <tr><td>Buyer</td><td>"+result[0]+"</td> </tr>\
        <tr><td>Seller</td><td>"+result[1]+"</td></tr>  \
        <tr><td>Miner</td><td>"+result[2]+"</td></tr>  \
        <tr><td>purchase_amount</td><td>"+result[3]+"</td></tr>  \
        <tr><td>Miner Reward</td><td>"+result[4]+"</td></tr>  \
        <tr><td>Buyer Reward</td><td>"+result[5]+"</td></tr>  \
        <tr><td>Seller Reward</td><td>"+result[6]+"</td></tr>"
        html_footer="</table>";
        final_html_content=html_header+html_content+html_footer;
        $("#transaction_details").html(final_html_content);
     });
  }
  get_transaction_nos();