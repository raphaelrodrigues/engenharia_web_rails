module ApplicationHelper

  # helper para ordenar os anuncios consuante a coluna e direcção
  def sortable(column, title = nil)
    title ||= column.titleize
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    #serve que quando se realiza uma pesquisa ao ordenar por paraemtro apenas ordene os resultados da pesquisa
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil)

  end

  #devolve os ultimos anuncios
  def ultimos_anuncios(num)
  	@ultimos10_anuncios = Anuncio.find(:all,:limit => num, :order=> 'created_at desc')
  end

  #devolve uma lista com username,id,numero de anuncios do user
  def ranking_anuncios
  	@lista_users = User.find_by_sql(%q{select u.username,u.id,count(a.id) as n_anuncios from Users u, Anuncios a where u.id = a.user_id group by u.username order by count(a.id) desc})
  end

  def id_cat2nome(category_id)
    @nome_categoria = Category.find_by_id(category_id).nome
  end




end
