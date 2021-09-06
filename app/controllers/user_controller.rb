require 'csv'

class UserController < ApplicationController
  def index
    #nothing to do here right now
  end

  def upload
    if valid_file?
      @users = []
      create_users_from_csv_file

      render template: "user/results", status: :ok
    else
      redirect_with_notice("Must upload a CSV file")
    end
  end

  private

  def valid_file?
    !(params[:users].nil? || !params[:users].content_type.include?('csv'))
  end

  def redirect_with_notice(msg)
    flash[:notice] = msg
    redirect_to action: 'index'
  end

  def create_users_from_csv_file
    uploaded_path = params[:users].path
    users_to_be_created = CSV.read(uploaded_path)

    # Always skipping headers, all CSV have header ;)
    users_to_be_created.drop(1).each do |name, password|
      @users << User.create(name: name, password: password)
    end
  end
end
