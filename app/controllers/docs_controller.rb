#
#
#
# Author: Scott Goyette
#
# Date:
#
class DocsController < ApplicationController
  before_action :find_doc, only: [:show, :edit, :update, :destroy]

  def index
    @docs = Doc.where(user_id: current_user).order("updated_at DESC")
  end

  def show
  end

  def new
    @doc = current_user.docs.build
  end

  def create
    @doc = current_user.docs.build(doc_params)

    if @doc.save
      redirect_to @doc, notice: 'Document Created Successfully.', time: 1500
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @doc.update(doc_params)
      redirect_to @doc, notice: 'Document Updated Successfully.', time: 1500
    else
      render 'edit'
    end
  end

  def destroy
    @doc.destroy
    redirect_to docs_path, notice: 'Document Deleted Successfully.', time: 1500
  end

  def export_word
    find_doc

    html = MarkdownToWord.convert(@doc.content)
    send_file "app/assets/downloads/#{@doc.title}.docx",
      :type =>
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      :disposition => 'attachment'
  end

  private

  def find_doc
    @doc = Doc.find(params[:id])
  end

  def doc_params
    params.require(:doc).permit(:title, :content)
  end
end
