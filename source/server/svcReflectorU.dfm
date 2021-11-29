object NetReflectorService: TNetReflectorService
  OldCreateOrder = False
  OnCreate = ServiceCreate
  OnDestroy = ServiceDestroy
  AllowPause = False
  DisplayName = 'Net Reflector Service'
  OnStart = ServiceStart
  OnStop = ServiceStop
  Height = 286
  Width = 492
end
