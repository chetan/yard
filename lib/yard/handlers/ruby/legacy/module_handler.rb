class YARD::Handlers::Ruby::Legacy::ModuleHandler < YARD::Handlers::Ruby::Legacy::Base
  handles TkMODULE
  
  def process
    modname = statement.tokens.to_s[/^module\s+(#{NAMESPACEMATCH})/, 1]
    mod = register ModuleObject.new(namespace, modname)
    parse_block(:namespace => mod)
  end
end