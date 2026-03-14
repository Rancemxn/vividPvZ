#ifndef __DECODER_H__
#define __DECODER_H__

// Minimal definitions for XA audio decoder interface

#define XA_SUCCESS 0
#define XA_ERROR_INVALID_PARAMETERS -1

#define XA_SYNC_API_VERSION 1

// Forward declarations
struct XA_OutputModuleQuery;
struct XA_DecoderInfo;

typedef struct XA_OutputInstance XA_OutputInstance;
typedef struct XA_OutputModuleClassInfo XA_OutputModuleClassInfo;

// Output module structure
typedef struct XA_OutputModule
{
    int api_version_id;
    int (*output_module_probe)(const char *name);
    int (*output_module_query)(XA_OutputModuleQuery *query, unsigned long query_mask);
    int (*output_new)(XA_OutputInstance **output, const char *name, XA_OutputModuleClassInfo *class_info, XA_DecoderInfo *decoder);
    int (*output_delete)(XA_OutputInstance *output);
    int (*output_open)(XA_OutputInstance *output);
    int (*output_close)(XA_OutputInstance *output);
    int (*output_write)(XA_OutputInstance *output, const void *buffer, unsigned long size, unsigned int bytes_per_sample, unsigned int nb_channels, unsigned int sample_rate);
    void* (*output_get_buffer)(XA_OutputInstance *output);
    int (*output_set_control)(XA_OutputInstance *output, int a, int b);
    int (*output_get_control)(XA_OutputInstance *output, int a, int *b);
    int (*output_get_status)(XA_OutputInstance *output, int a, void *b);
    int (*output_get_caps)(XA_OutputInstance *output, int a, void *b);
    int (*output_send_message)(XA_OutputInstance *output, int a, void *b);
} XA_OutputModule;

// Registration function
int memory_output_module_register(XA_OutputModule *module);

#endif // __DECODER_H__
