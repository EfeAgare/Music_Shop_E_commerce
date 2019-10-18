class CheckoutsController < ApplicationController


  ## first create the transaction Status
  TRANSACTION_SUCCESS_STATUSES = [
    Braintree::Transaction::Status::Authorizing,
    Braintree::Transaction::Status::Authorized,
    Braintree::Transaction::Status::Settled,
    Braintree::Transaction::Status::SettlementConfirmed,
    Braintree::Transaction::Status::SettlementPending,
    Braintree::Transaction::Status::Settling,
    Braintree::Transaction::Status::SubmittedForSettlement,
  ]


  ## 2 create the gateway

  def gateway
    env = ENV["BT_ENVIRONMENT"]

    @gateway ||= Braintree::Gateway.new(
      :environment => env && env.to_sym,
      :merchant_id => ENV["BT_MERCHANT_ID"],
      :public_key => ENV["BT_PUBLIC_KEY"],
      :private_key => ENV["BT_PRIVATE_KEY"],
    )
  end


  ## 3 generate a client token

  def new
    @client_token = gateway.client_token.generate(:customer_id => current_user.id)
  end


  ## 4 Receive a payment method nonce from your client
  def create
    amount = params["amount"] # In production you should not take amounts directly from clients

    ## here we are recieving the payment nonce
    nonce = params["payment_method_nonce"]

    ## create a transaction
    result = gateway.transaction.sale(
      amount: amount,
      payment_method_nonce: nonce,
      :options => {
        :submit_for_settlement => true
      }
    )

    if result.success? || result.transaction
      redirect_to checkout_path(result.transaction.id)
    else
      error_messages = result.errors.map { |error| "Error: #{error.code}: #{error.message}" }
      flash[:error] = error_messages
      redirect_to new_checkout_path
    end
  end
  

  def _create_result_hash(transaction)
    status = transaction.status

    if TRANSACTION_SUCCESS_STATUSES.include? status
      {
        :header => "Sweet Success!",
        :icon => "success",
        :message => "Your test transaction has been successfully processed"
      }
    else
      {
        :header => "Transaction Failed",
        :icon => "fail",
        :message => "Your test transaction has a status of #{status}"
      }
    end
  end


  ## show method
  def show
    @transaction = gateway.transaction.find(params[:id])
    @result = _create_result_hash(@transaction)
  end
end
