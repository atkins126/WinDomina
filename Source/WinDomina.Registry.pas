unit WinDomina.Registry;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  WinDomina.Types,
  WinDomina.Layer;

// WDMKeyStates protokolliert den Zustand der Tasten im WinDomina-Modus
procedure RegisterWDMKeyStates(States: TKeyStates);
function WDMKeyStates: TKeyStates;

// LayerActivationKeys h�lt eine Liste zwischen den Aktivierungstasten und dem entsprechenden Layer
procedure RegisterLayerActivationKeys(List: TKeyLayerList);
function LayerActivationKeys: TKeyLayerList;

// DominaWindows h�lt eine Liste von Fenstern, die sich aktuell unter Kontrolle von WinDomina
// befinden
procedure RegisterDominaWindows(DominaWindows: TWindowList);
function DominaWindows: TWindowList;
procedure BroadcastDominaWindowsChangeNotify;
procedure RegisterDominaWindowsChangeNotify(EventHandler: TProc; Implementor: TObject);
procedure UnregisterDominaWindowsChangeNotify(Implementor: TObject);

implementation

threadvar
  WDMKS: TKeyStates;

procedure RegisterWDMKeyStates(States: TKeyStates);
begin
  WDMKS.Free;
  WDMKS := States;
end;

function WDMKeyStates: TKeyStates;
begin
  Result := WDMKS;
end;

threadvar
  LAK: TKeyLayerList;

procedure RegisterLayerActivationKeys(List: TKeyLayerList);
begin
  LAK.Free;
  LAK := List;
end;

function LayerActivationKeys: TKeyLayerList;
begin
  Result := LAK;
end;

type
  TDWChangeEventsDictionary = TDictionary<TObject, TProc>;

threadvar
  DW: TWindowList;
  DWChangeEvents: TDWChangeEventsDictionary;

procedure RegisterDominaWindows(DominaWindows: TWindowList);
begin
  DW.Free;
  DW := DominaWindows;
end;

function DominaWindows: TWindowList;
begin
  Result := DW;
end;

procedure BroadcastDominaWindowsChangeNotify;
var
  EventHandler: TProc;
begin
  for EventHandler in DWChangeEvents.Values do
    EventHandler;
end;

procedure RegisterDominaWindowsChangeNotify(EventHandler: TProc; Implementor: TObject);
begin
  DWChangeEvents.AddOrSetValue(Implementor, EventHandler);
end;

procedure UnregisterDominaWindowsChangeNotify(Implementor: TObject);
begin
  DWChangeEvents.Remove(Implementor);
end;

initialization
DWChangeEvents := TDWChangeEventsDictionary.Create;

finalization
FreeAndNil(WDMKS);
FreeAndNil(LAK);
FreeAndNil(DWChangeEvents);
FreeAndNil(DW);

end.