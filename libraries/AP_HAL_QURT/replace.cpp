#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <dirent.h>
#include <pthread.h>
#include "replace.h"
#include "interface.h"

extern qurt_func_ptrs_t qurt_func_ptrs;

extern "C" {

// this is not declared in qurt headers
void HAP_debug(const char *msg, int level, const char *filename, int line);
    
void HAP_printf(const char *file, int line, const char *format, ...)
{
	va_list ap;
        char buf[300];
        
	va_start(ap, format);
	vsnprintf(buf, sizeof(buf), format, ap);
	va_end(ap);
        HAP_debug(buf, 0, file, line);
        //usleep(20000);
}
    
/**
   QURT doesn't have strnlen()
**/
size_t strnlen(const char *s, size_t max)
{
        size_t len;
  
        for (len = 0; len < max; len++) {
                if (s[len] == '\0') {
                        break;
                }
        }
        return len;  
}

int vasprintf(char **ptr, const char *format, va_list ap)
{
	int ret;
	va_list ap2;

	va_copy(ap2, ap);
	ret = vsnprintf(nullptr, 0, format, ap2);
	va_end(ap2);
	if (ret < 0) return ret;

	(*ptr) = (char *)malloc(ret+1);
	if (!*ptr) return -1;

	va_copy(ap2, ap);
	ret = vsnprintf(*ptr, ret+1, format, ap2);
	va_end(ap2);

	return ret;
}

int asprintf(char **ptr, const char *format, ...)
{
	va_list ap;
	int ret;
	
	*ptr = nullptr;
	va_start(ap, format);
	ret = vasprintf(ptr, format, ap);
	va_end(ap);

	return ret;
}

void *memmem(const void *haystack, size_t haystacklen,
                    const void *needle, size_t needlelen)
{
	if (needlelen == 0) {
        return const_cast<void*>(haystack);
	}
	while (haystacklen >= needlelen) {
		char *p = (char *)memchr(haystack, *(const char *)needle,
                                 haystacklen-(needlelen-1));
		if (!p) return NULL;
		if (memcmp(p, needle, needlelen) == 0) {
			return p;
		}
		haystack = p+1;
		haystacklen -= (p - (const char *)haystack) + 1;
	}
	return NULL;
}

char *strndup(const char *s, size_t n)
{
	char *ret;
	
    n = strnlen(s, n);
    ret = (char*)malloc(n+1);
    if (!ret) {
        return NULL;
    }
	memcpy(ret, s, n);
	ret[n] = 0;

	return ret;
}

int pthread_cond_init(pthread_cond_t *cond, pthread_condattr_t *attr)
{
       return 0;
}

// INVESTIGATE: What is this needed on QURT?
int apfs_rename(const char *oldpath, const char *newpath)
{
       return 0;
}

// INVESTIGATE: How to enable
void lua_abort() {}
const char* lua_get_modules_path() {return NULL;}
int lua_get_current_ref() {return 0;}

// INVESTIGATE: Seems important :-)
int ArduPilot_main(int argc, const char *argv[])
{
       return 0;
}

}

extern "C" int qurt_arducopter_main(int argc, char* const argv[]);

int px4muorb_orb_initialize(qurt_func_ptrs_t *func_ptrs, int32_t clock_offset_us)
{
	HAP_PRINTF("About to call qurt_arducopter_main %p", &qurt_arducopter_main);

    qurt_func_ptrs = *func_ptrs;
    HAP_PRINTF("qurt_func_ptrs->_config_i2c_bus_func_t=%p", qurt_func_ptrs._config_i2c_bus_func_t);

	qurt_arducopter_main(0, NULL);

    HAP_PRINTF("qurt_arducopter_main RETURNED");

    return 0;
}

int px4muorb_topic_advertised(const char *name)
{
       return 0;
}

int px4muorb_add_subscriber(const char *name)
{
       return 0;
}

int px4muorb_remove_subscriber(const char *name)
{
       return 0;
}

int px4muorb_send_topic_data(const char *name, const uint8_t *data, int data_len_in_bytes)
{
       return 0;
}

float px4muorb_get_cpu_load(void)
{
       return 0.0f;
}

