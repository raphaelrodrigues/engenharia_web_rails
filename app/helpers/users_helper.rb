module UsersHelper


	def to_s_status(status)

		case status
		when "M"
			a = 'Moderador'
		when "R"
			a = 'Registado'
		when "A"
			a = 'Administrador'
		end

		return a
	end
	
	def to_s_moderador(dashboard)

		case dashboard
		when "N"
			a = 'Normal'
		when "E"
			a = 'Estatisticas'
		end

		return a
	end
end
