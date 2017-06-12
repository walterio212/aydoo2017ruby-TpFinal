class EventoDuracionMaximaInvalidaError < StandardError
  
    def initialize(msg="El evento debe ser menor a 72 horas")
      super
    end
  
end