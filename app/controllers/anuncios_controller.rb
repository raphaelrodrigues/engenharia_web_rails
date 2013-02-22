class AnunciosController < ApplicationController
  include Paperclip::Glue

  skip_before_filter :authorize, :except => :new
  helper_method :sort_column, :sort_direction,:get_nome_categoria

  #before_filter :authorize_moderador,:only =>[ :edit ]
  before_filter :correct_anuncio , only: [ :edit , :update , :destroy]
  
  # GET /anuncios
  # GET /anuncios.json
  def index
    @anuncios = Anuncio.order(sort_column + " " + sort_direction).paginate(:per_page => 9, :page => params[:page]).search(params[:nome],"",params[:category_id])
    @categories = Category.find( :all , :order => 'nome ')

    
    respond_to do |format|
      format.js
      format.html # index.html.erb
      format.xml  { render :xml => @anuncios }
    end
  end

  # /venda
  def venda
    @anuncios = Anuncio.order(sort_column + " " + sort_direction).paginate(:page => params[:page],:per_page => 9).search(params[:nome],"Venda",params[:category_id]) 
    @categories = Category.find( :all , :order => 'nome ')
  end

  # /compra
  def compra
    @anuncios = Anuncio.order(sort_column + " " + sort_direction).paginate(:page => params[:page],:per_page => 9).search(params[:nome],"Compra",params[:category_id]) 
    @categories = Category.find( :all , :order => 'nome ')
  end

  def troca
    @anuncios = Anuncio.order(sort_column + " " + sort_direction).paginate(:page => params[:page],:per_page => 9).search(params[:nome],"Troca",params[:category_id]) 
    @categories = Category.find( :all , :order => 'nome ')
  end

  # /desactivos
  def desactivos
    @anuncios = Anuncio.order(sort_column + " " + sort_direction).paginate(:page => params[:page],:per_page => 9).desactivos
  end

  def activar
    @anuncio = Anuncio.find(params[:id])
    @anuncio.activo = 1
    @anuncio.save

    render :show
  end

  def desactivar
    @anuncio = Anuncio.find(params[:id])
    @anuncio.activo = 0
    @anuncio.save

    render :show

  end

  # /dashboard
  def dashboard
    @categories = Category.find( :all , :order => 'nome ')

    @destaques1 = Anuncio.find(:all,:conditions =>[ "destaque = ?",true],:limit => 4,:order => "preco asc")
    @destaques2 = Anuncio.find(:all,:conditions =>[ "destaque = ?",true],:limit => 4,:order => "preco desc")

    respond_to do |format|
      format.js
      format.html # index.html.erb
      format.xml  { render :xml => @categories }
    end
  end

  # GET /anuncios/1
  # GET /anuncios/1.json
  def show
    @anuncio = Anuncio.find(params[:id])

    category_id = @anuncio.category_id

    #buscar anuncios parecidos mesma catgoria por exemplo
    @anuncios_relacionados = Anuncio.find(:all, :conditions =>[ "category_id = ?",category_id],:limit => 3)

    if !@anuncio.category_id.blank?
       @category_name = Category.find(@anuncio.category_id).nome
    else
        @category_name = "Sem Categoria"
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @anuncio }
    end
  end

  #devolve valores para os graficos das estatisticas
  def estatisticas


      @obj1 = categoria_percent
        
      @obj = avg_price_categoria

      @h = get_grafico(@obj,"bar")

      @h1 = get_grafico(@obj1,"pie")
  end

  # GET /anuncios/new
  # GET /anuncios/new.json
  def new
    @anuncio = Anuncio.new
    @categories = Category.all
    
    3.times { @anuncio.assets.build }

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @anuncio }
    end
  end

  # GET /anuncios/1/edit
  def edit
    @anuncio = Anuncio.find(params[:id])
    @categories = Category.find( :all , :order => 'nome ')
    3.times { @anuncio.assets.build }

  end

  # POST /anuncios
  # POST /anuncios.json
  def create
    @anuncio = Anuncio.new(params[:anuncio])
    @categories = Category.find( :all , :order => 'nome ')

    respond_to do |format|
      if @anuncio.save
        format.html { redirect_to @anuncio, notice: 'Anuncio was successfully created.' }
        format.json { render json: @anuncio, status: :created, location: @anuncio }
      else
        format.html { render action: "new" }
        format.json { render json: @anuncio.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /anuncios/1
  # PUT /anuncios/1.json
  def update
    @anuncio = Anuncio.find(params[:id])

    respond_to do |format|
      if @anuncio.update_attributes(params[:anuncio])
        format.html { redirect_to @anuncio, notice: 'Anuncio was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @anuncio.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /anuncios/1
  # DELETE /anuncios/1.json
  def destroy
    @anuncio = Anuncio.find(params[:id])
    @anuncio.destroy

    respond_to do |format|
      format.html { redirect_to anuncios_url,:notice => "Anuncio apagado com sucesso" }
      format.json { head :no_content }
    end
  end

  def find_anuncios

    @categories = Category.find( :all , :order => 'nome ')

    @anuncios = Anuncio.advanced_search(params[:nome],params[:minimum_price],params[:maximum_price],params[:category_id],params[:tipo])

  end

private
  def sort_column
    #coluna default da pesquisa
    params[:sort] || "nome" 
  end
  
  def sort_direction
    #default ascendente da pesquisa
    params[:direction] || "asc" 
  end




  

end
