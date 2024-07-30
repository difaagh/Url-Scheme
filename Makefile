ARCH = arm64 arm64e
TARGET := iphone:clang:latest:15.0
INSTALL_TARGET_PROCESSES = SpringBoard


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = UrlScheme

UrlScheme_FILES = Tweak.x
UrlScheme_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
