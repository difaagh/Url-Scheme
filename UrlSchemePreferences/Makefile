ARCH = arm64 arm64e
TARGET := iphone:clang:16.5:14.5

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = UrlSchemePreferences

UrlSchemePreferences_FILES = USPRootListController.m
UrlSchemePreferences_FRAMEWORKS = Foundation
UrlSchemePreferences_PRIVATE_FRAMEWORKS = Preferences
UrlSchemePreferences_INSTALL_PATH = /Library/PreferenceBundles
UrlSchemePreferences_CFLAGS = -fobjc-arc
UrlSchemePreferences_EXTRA_FRAMEWORKS = AltList

include $(THEOS_MAKE_PATH)/bundle.mk
