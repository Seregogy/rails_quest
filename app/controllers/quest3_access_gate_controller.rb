class Quest3AccessGateController < ApplicationController
  # TODO: Add routes in config/routes.rb and finish the controller logic for Quest 3.
  # The quest expects a mix of GET / POST / PATCH / DELETE, conditional redirects,
  # and visible before_action / after_action callbacks.

  # Quest3DataService probes POST/PATCH/DELETE actions without a browser CSRF token.
  # Disable CSRF verification here so the probe can validate route/controller logic.
  skip_forgery_protection

  before_action :prepare_sum, only: [ :clearance ]
  after_action :set_header, only: [ :clearance ]

  before_action :extract_token, only: [ :granted ]
  after_action :set_header_granted, only: [ :granted ]

  # Register callbacks here.


  def ping
    render plain: "ACCESSGATE PING OK"
  end

  def scan
    agent = params[:agent]
    sector = params[:sector]

    render plain: "SCAN RESULT: #{agent} -> sector #{sector}"
  end

  def power
    render plain: "POWER TOTAL: #{params[:current].to_i + params[:boost].to_i}"
  end

  def stale_logs
    render plain: "STALE LOGS CLEARED: #{params[:count]}"
  end

  def clearance
    render plain: "CLEARANCE TOTAL: #{@sum}"
  end

  def verify
    if params[:token].start_with?("alpha")
      redirect_to action: :granted, token: params[:token]
    else
      redirect_to action: :denied, token: params[:token]
    end
  end

  def granted
    render plain: "TOKEN ACCEPTED: #{@token}"
  end

  def denied
    render plain: ""
  end

  private

  def prepare_sum
    @sum = params[:level].to_i + params[:boost].to_i
  end

  def set_header
    response.set_header("X-Access-Gate-Trace", "CLEAREANCE_GRANTED")
  end

  def extract_token
    @token = params[:token]
  end

  def set_header_granted
    response.set_header("X-Access-Gate-Trace", "token_checked")
  end
end
