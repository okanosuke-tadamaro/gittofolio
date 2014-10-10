class ApiController < ApplicationController

  respond_to :json
  before_filter :define_access_control_headers
  before_filter :check_user_existence
  before_filter :validate_user

  def activity
    user = User.find_by(login: params[:user])
    repositories = user.repositories
    return_data = Repository.get_linechart_data(user.login, user.github_access_token)
    render json: { status: true, data: return_data }.to_json
  end

  def repositories
    user = User.find_by(login: params[:user])
    repositories = user.repositories.where(display: true)
    repositories = Repository.construct_return_data(api_client, repositories)
    render json: repositories.to_json
  end

  private

  def define_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  def validate_user
    user = User.find_by(login: params[:user])
    unless user.websites.exists?(url: request.env['REMOTE_HOST']) || true
      render json: { status: false, msg: 'Invalid API Request' }
    end
  end

  def api_client
    Octokit::Client.new(access_token: User.find_by(login: params[:user]).github_access_token)
  end

end
