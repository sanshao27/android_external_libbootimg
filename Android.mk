LOCAL_PATH := $(call my-dir)

libbootimg_src := libbootimg.c
libbootimg_cflags := -Os

bootimg_src := bootimg.c
bootimg_cflags := -Os

bootimg_static_libs :=
bootimg_shared_libs :=

ifdef BOOTIMG_STATIC
	bootimg_static_libs += libbootimg-static
else
	bootimg_shared_libs += libbootimg
endif

ifndef BOOTIMG_NO_SHA
	libbootimg_src += mincrypt/sha.c
	libbootimg_cflags += -DENABLE_SHA
endif

ifdef BOOTIMG_LOGGING
	bootimg_cflags += -DDEBUG
	bootimg_shared_libs += liblog
endif

include $(CLEAR_VARS)
LOCAL_MODULE := libbootimg-static
LOCAL_SRC_FILES := $(libbootimg_src)
LOCAL_CFLAGS += $(libbootimg_cflags)
LOCAL_MODULE_TAGS := optional
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := libbootimg
LOCAL_SRC_FILES := $(libbootimg_src)
LOCAL_CFLAGS += $(libbootimg_cflags)
LOCAL_MODULE_TAGS := optional
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := bootimg
LOCAL_SRC_FILES := $(bootimg_src)
LOCAL_CFLAGS += $(bootimg_cflags)
LOCAL_STATIC_LIBRARIES := $(bootimg_static_libs)
LOCAL_SHARED_LIBRARIES := $(bootimg_shared_libs)
LOCAL_MODULE_TAGS := optional
include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_MODULE := bootimg
LOCAL_SRC_FILES := $(bootimg_src) $(libbootimg_src)
LOCAL_CFLAGS += $(libbootimg_cflags)
LOCAL_MODULE_TAGS := optional
include $(BUILD_HOST_EXECUTABLE)
