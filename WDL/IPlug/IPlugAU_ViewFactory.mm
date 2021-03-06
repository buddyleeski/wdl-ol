#import <Cocoa/Cocoa.h>
#include "../IPlug/IGraphicsCocoa.h"
#include "resource.h"   // This is your plugin's resource.h.

static const AudioUnitPropertyID kIPlugObjectPropertyID = UINT32_MAX-100;

@interface VIEW_CLASS : NSObject <AUCocoaUIBase>
{
  IPlugBase* mPlug;
}
- (id) init;
- (NSView*) uiViewForAudioUnit: (AudioUnit) audioUnit withSize: (NSSize) preferredSize;
- (unsigned) interfaceVersion;
- (NSString*) description;
@end

@implementation VIEW_CLASS

- (id) init
{
  TRACE;  
  mPlug = 0;
  return [super init];
}

- (NSView*) uiViewForAudioUnit: (AudioUnit) audioUnit withSize: (NSSize) preferredSize
{
  TRACE;

  void* pointers[1];
  UInt32 propertySize = sizeof (pointers);
  
  if (AudioUnitGetProperty (audioUnit, kIPlugObjectPropertyID,
                            kAudioUnitScope_Global, 0, pointers, &propertySize) == noErr)
  {
    mPlug = (IPlugBase*) pointers[0];
    if (mPlug) {
      IGraphics* pGraphics = mPlug->GetGUI();
      if (pGraphics) {
        IGRAPHICS_COCOA* pView = (IGRAPHICS_COCOA*) pGraphics->OpenWindow(0);
        mPlug->OnGUIOpen();
        return pView;
      }
    }
  }
  return 0;
}

- (unsigned) interfaceVersion
{
  return 0;
}

- (NSString *) description
{
  return ToNSString(PLUG_NAME " View");
}

@end


