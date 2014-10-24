class CommentsController < ApplicationController
  before_filter :authenticate_user!
  # lol embedded documents
  before_filter :find_book_and_chapter_and_note

  def create
    @comments = @note.comments
    check_for_state_transition!
    if params[:comment][:text].present?
      @comment = @note.comments.build(comment_params)
      @comment.user = current_user
      if @comment.save
        @comment.send_notifications!
        flash[:notice] ||= "Comment has been created."
        redirect_to [@book, @chapter, @note]
      else
        flash[:error] = "Comment could not be created."
        render "notes/show"
      end
    else
      redirect_to [@book, @chapter, @note]
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:text)
  end

  def check_for_state_transition!
    if current_user.author?
      case params[:commit]
      when "Accept"
        @note.accept!
        notify_of_note_state_change("Accepted")
      when "Reject"
        @note.reject!
        notify_of_note_state_change("Rejected")
      when "Reopen"
        @note.reopen!
        notify_of_note_state_change("Reopened")
      end
    end
  end

  def notify_of_note_state_change(state)
    flash[:notice] = "Note state changed to #{state}"
  end

  def find_book_and_chapter_and_note
    @book = Book.where(permalink: params[:book_id]).first
    @chapter = @book.chapters.where(:position => params[:chapter_id]).first
    @note = @chapter.notes.where(:number => params[:note_id]).first
  end
  
end
