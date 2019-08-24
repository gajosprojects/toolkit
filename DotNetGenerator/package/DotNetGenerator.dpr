program DotNetGenerator;

uses
  Vcl.Forms,
  uEntidadeDTO in '..\dtos\uEntidadeDTO.pas',
  uAtributoDTO in '..\dtos\uAtributoDTO.pas',
  service_api_viewmodels_generator in '..\functions\service_api_viewmodels_generator.pas',
  service_api_controller_generator in '..\functions\service_api_controller_generator.pas',
  infra_data_repository_generator in '..\functions\infra_data_repository_generator.pas',
  infra_data_mapping_generator in '..\functions\infra_data_mapping_generator.pas',
  infra_data_context_generator in '..\functions\infra_data_context_generator.pas',
  domain_entity_generator in '..\functions\domain_entity_generator.pas',
  domain_commands_generator in '..\functions\domain_commands_generator.pas',
  domain_events_generator in '..\functions\domain_events_generator.pas',
  domain_repository_generator in '..\functions\domain_repository_generator.pas',
  uMainForm in '..\uMainForm.pas' {MainForm},
  uDotNetGeneratorSourceCodeFrame in '..\uDotNetGeneratorSourceCodeFrame.pas' {DotNetGeneratorSourceCodeFrame: TFrame},
  uMainDataModule in '..\uMainDataModule.pas' {MainDataModule: TDataModule},
  uConstantes in '..\uConstantes.pas' {$R *.res},
  uSerializadorXML in '..\uSerializadorXML.pas',
  uArquivoDTO in '..\dtos\uArquivoDTO.pas',
  MSXML2_TLB in '..\MSXML2_TLB.pas',
  tests_integration_generator in '..\functions\tests_integration_generator.pas',
  uStringHelper in '..\helper\uStringHelper.pas',
  tests_integration_dto_generator in '..\functions\tests_integration_dto_generator.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainDataModule, MainDataModule);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
