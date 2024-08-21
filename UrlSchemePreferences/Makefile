ARCH = arm64 arm64e
TARGET := iphone:clang:latest:14.5
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = UrlSchemePreferences

UrlSchemePreferences_FILES = $(wildcard USP*.*m)
UrlSchemePreferences_FRAMEWORKS = UIKit
UrlSchemePreferences_PRIVATE_FRAMEWORKS = Preferences
UrlSchemePreferences_INSTALL_PATH = /Library/PreferenceBundles
UrlSchemePreferences_CFLAGS = -fobjc-arc
UrlSchemePreferences_EXTRA_FRAMEWORKS = AltList

include $(THEOS_MAKE_PATH)/bundle.mk
