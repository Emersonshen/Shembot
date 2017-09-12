class CommandsController < ApplicationController

  def index
    @commands = Command.search(params[:page])
  end

  def addCommand
    redirect_to :back
    if params[:commandName] != ""
      if !Command.exists?(name: params[:commandName])
        @command = Command.new
        @command.name = params[:commandName]
        @command.text = params[:commandText]
        @command.args = params[:args]
        @command.save
      end
    end
  end

  def editCommand
    redirect_to :back

  end
end
