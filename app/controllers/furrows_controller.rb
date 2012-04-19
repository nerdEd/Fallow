class FurrowsController < ApplicationController

  before_filter :require_user

  def index
    @furrows = @current_user.furrows.active
    @furrow = Furrow.new(:user => @current_user, :seed_user => User.new)
    @current_user = current_user
  end

  def new
    @current_user = current_user
    @furrow = Furrow.new(:user => @current_user, :seed_user => User.new)
  end

  def cancel
    @furrow = @current_user.furrows.active.find(params[:id])
    @furrow.finish! if @furrow
    pending_job = Delayed::Job.find(@furrow.delayed_job_id)
    pending_job.destroy if pending_job
    redirect_to furrows_path
  end

  def create
    seed_user = User.new_from_nickname(params['furrow']['user']['nickname'])

    @furrow = Furrow.new(params['furrow'].merge({:user => current_user, :seed_user => seed_user}))

    if @furrow.save
      flash[:notice] = "Great Success! You will now #{@furrow.action} @#{@furrow.seed_user.nickname} for #{@furrow.duration} day(s)"
      @furrow.start!
      job = @furrow.delay(:run_at => (Date.today + @furrow.duration.days)).finish!
      @furrow.update_attribute(:delayed_job_id, job.id)
      redirect_to furrows_path
    else
      @current_user = current_user
      @invalid_furrow = 'yes'
      @furrows = @current_user.furrows.active
      render :index
    end
  end
end
