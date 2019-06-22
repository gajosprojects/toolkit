program DotNetGenerator;

uses
  Vcl.Forms,
  uMain in '..\uMain.pas' {Main},
  uEntidadeDTO in '..\dtos\uEntidadeDTO.pas',
  uAtributoDTO in '..\dtos\uAtributoDTO.pas',
  service_api_view_model_generator in '..\functions\service_api_view_model_generator.pas',
  service_api_controller_generator in '..\functions\service_api_controller_generator.pas',
  infra_data_repository_generator in '..\functions\infra_data_repository_generator.pas',
  infra_data_mapping_generator in '..\functions\infra_data_mapping_generator.pas',
  infra_data_context_generator in '..\functions\infra_data_context_generator.pas',
  domain_entity_generator in '..\functions\domain_entity_generator.pas',
  domain_commands_generator in '..\functions\domain_commands_generator.pas',
  domain_events_generator in '..\functions\domain_events_generator.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
