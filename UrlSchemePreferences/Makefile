ARCH = arm64 arm64e
TARGET := iphone:clang:latest:15.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = UrlSchemePreferences

UrlSchemePreferences_FILES = USPRootListController.m
UrlSchemePreferences_FRAMEWORKS = UIKit
UrlSchemePreferences_PRIVATE_FRAMEWORKS = Preferences
UrlSchemePreferences_INSTALL_PATH = /Library/PreferenceBundles
UrlSchemePreferences_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
