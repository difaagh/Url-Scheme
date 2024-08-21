ARCH = arm64 arm64e
TARGET := iphone:clang:latest:14.5
INSTALL_TARGET_PROCESSES = SpringBoard


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = UrlScheme

UrlScheme_FILES = Tweak.x
UrlScheme_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += UrlSchemePreferences
include $(THEOS_MAKE_PATH)/aggregate.mk
