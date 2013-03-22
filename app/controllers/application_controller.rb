class ApplicationController < ActionController::Base
  include ActionView::Helpers::NumberHelper
  protect_from_forgery

  before_filter :authorize
  helper_method :current_user,:signed_in?,:isAdmin? ,:isModerador?,:isRegistado?, :belongs_toUser?,:isActivo?,:quantas_imagens_tem?,:get_nome_categoria # This makes these methods available in views
  helper_method :get_grafico_anuncio_categoria,:get_grafico_precos_medios_cat,:tempo_registo,:correct_anuncio,:correct_user


  #metodo usado para permissoes
  def current_user
		if session[:user_id]
		    @current_user = User.find(session[:user_id])
		else
		    @current_user = nil
		end
		    @current_user
  end

  #verifica se está com ligin feito
  def signed_in?
	 !!current_user
  end

  #verifica se tem permissoes de admin
  def isAdmin?
    if session[:perm] == 1
      return true;
    else
      return false;
    end
  end

  #verifica se tem permissoes de moderador
  def isModerador?
    if session[:perm] == 2
      return true;
    else
      return false;
    end
  end

  #verifica se tem permissoes de registado
  def isRegistado?
    if session[:perm] == 0
      return true;
    else
      return false;
    end
  end

  #verifica quantas imagens tem uma anuncio
  def quantas_imagens_tem?(val)
    return val
  end

  #verifica se anuncio esta activo
  def isActivo?(activo)
    if activo == 1
      return true;
    else
      return false;
    end
  end

  #verifica se anuncio pertence ao utilizador da sessao actual
  def belongs_toUser?(user_id)
    if session[:user_id] == user_id
      return true
    else
      return false
    end
  end

  # devolve a percentagem de anuncios por categoria
  def categoria_percent
        
        obj1 = Array.new
        num_anuncios = Anuncio.all.count
        Category.all.each do |c|
          val = (c.anuncios.count.to_f / num_anuncios) * 100

          obj1.push([ c.nome, val ])
        end

        return obj1
  end

   # devolve o preco medio de anuncio de cada categoria
  def avg_price_categoria
      obj = Array.new
      Category.all.each do |c|

          c.anuncios.average(:preco) == nil ? (val = 0) : (val = c.anuncios.average(:preco).to_f)
          
          obj.push([ c.nome, val ] )

        end

      return obj
  end

  #get nome id a partir do category_id
  def get_nome_categoria(id)
      category = Category.find(id)

      @category_name = category.nome

      return @category_name
  end 

  #devolve uma grafico generico 
  def get_grafico(obj,tipo_grafico)

   return  @h = LazyHighCharts::HighChart.new('pie') do |f|
          f.chart({:defaultSeriesType=>tipo_grafico , :margin=> [50, 200, 60, 170]} )
          series = {
                   :type=> tipo_grafico,
                   :name=> 'Media de precos dos anuncios',
                   :data=> obj,

          }
          f.series(series)

          f.options[:title][:text] = "Preco por categoria"

          f.legend(:layout=> 'vertical',:style=> {:left=> 'auto', :bottom=> 'auto',:right=> '50px',:top=> '100px'}) 
          f.plot_options(:pie=>{
            :allowPointSelect=>true, 
            :cursor=>"pointer" , 
            :dataLabels=>{
              :enabled=>true,
              :color=>"white",
              :style=>{
                :font=>"13px Trebuchet MS, Verdana, sans-serif"
              }
            }
          })
        end
  end

  #da grafico das estatisticas
  def get_grafico_anuncio_categoria

   obj1 = categoria_percent

   return  @h = LazyHighCharts::HighChart.new('pie') do |f|
          f.chart({:defaultSeriesType=>"pie" , :margin=> [30, 70, 0, 70]} )
          series = {
                   :type=> "pie",
                   :name=> 'Percentagem de Anuncios por categoria',
                   :data=> obj1
          }
          f.series(series)
          f.options[:title][:text] = "Percentagem de anuncios por categoria"
          f.legend(:layout=> 'vertical',:style=> {:left=> 'auto', :bottom=> 'auto',:right=> '50px',:top=> '100px'}) 
          f.plot_options(:pie=>{
            :allowPointSelect=>true, 
            :cursor=>"pointer" , 
            :dataLabels=>{
              :enabled=>true,
              :color=>"white",
              :style=>{
                :font=>"13px Trebuchet MS, Verdana, sans-serif",
                :width => "50px",
                :height => "50px" 
              }
            }
          })
        end
  end



   #da grafico das estatisticas
  def get_grafico_precos_medios_cat

   obj1 = avg_price_categoria

   return  @h = LazyHighCharts::HighChart.new('pie') do |f|
          f.chart({:defaultSeriesType=>"bar" ,type: 'column',renderTo: 'container', :margin=> [10, 100, 60, 100]} )
          series = {
                   :type=> 'column',
                   :name=> 'Media de precos por categoria',
                   :data=> obj1
          }
          f.series(series)
          f.options[:title][:text] = "Preco por categoria"
          f.options[:xAxis] = {

              :title => { :text => "categorias" },
              :labels => { :enabled => false }
           }
          f.legend(:layout=> 'vertical',:style=> {:left=> 'auto', :bottom=> 'auto',:right=> '50px',:top=> '50px'}) 
          f.plot_options(:pie=>{
            :allowPointSelect=>true, 
            :cursor=>"pointer" , 
            :dataLabels=>{
              :enabled=>true,
              :color=>"white",
              :style=>{
                :font=>"13px Trebuchet MS, Verdana, sans-serif",
                :width => "250px",
                :height => "150px" 
              }
            }
          })
        end
  end

  




private
  #metodos para gerir permissoes
  def correct_user
    @user = User.find(params[:id])
    redirect_to "/anuncios" unless  current_user
  end

  def correct_anuncio
    @anuncio = Anuncio.find(params[:id])
    redirect_to "/anuncios" unless  belongs_toUser?(@anuncio.user_id) || isModerador?
  end

protected
 

   # Checks that user is logged in
  def authorize
    redirect_to "/log_in", :alert => t('.need_to_be_logged_in') unless signed_in?
  end

  # verfica se é admin
  def authorize_admin
    redirect_to "/anuncios" unless isAdmin?
  end

  #verifica se é modoredor
  def authorize_moderador 
    redirect_to "/anuncios" unless isModerador?
  end

  #verifica se é modoredor ou administrador
  def authorize_backend
    redirect_to "/anuncios" unless isModerador?
  end

	
end
