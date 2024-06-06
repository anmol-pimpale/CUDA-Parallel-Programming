
#include<stdio.h>
#include<stdlib.h>
#include<CL/cl.h>

#define N 1

const char *kernelSource=
"__kernel void arrayAdd(__global  int *a,__global int *b,__global int *c){\n"
"  int i= get_global_id(0);\n"
"  c[i]=a[i]+b[i];\n"
"}\n";

int main(){
  cl_platform_id platform;
  cl_device_id device;
  cl_context context;
  cl_command_queue queue;
  cl_program program;
  cl_kernel kernel;
  cl_mem bufferA,bufferB,bufferC;
  cl_event event;
  cl_int err;


  //initialisation input
int *a = (int *)malloc(sizeof(int));
int *b = (int *)malloc(sizeof(int));
int *c = (int *)malloc(sizeof(int));

*a=222;
*b=333;

//step 1: create openCl context and command queue
clGetPlatformIDs(1,&platform,NULL);
clGetDeviceIDs(platform, Cl_DEVICE_TYPE_GPU , 1, &device, NULL);

context = clCreateContext(NULL, 1, &device, NULL,NULL,NULL);
queue = clCreateCommonQueue(contex, device, 0 , NULL);

//step 2:create and build opencl program
program = clCreateProgramWithSource(context , 1 , (const char**)&kerenelSource, NULL,NULL);
clBuildProgram(program, 1, &device, NULL ,NULL, NULL);
   
//step 3:create kernel
kernel=clCreateKernel(program,"arrayAdd",NULL);

//step 4:create memory bufferA
bufferA=clCreateBuffer(context,CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR,sizeof(int),a,NULL);
bufferB=clCreateBuffer(context,CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR,sizeof(int),b,NULL);
bufferC=clCreateBuffer(context,CL_MEM_WRITE_ONLY,sizeof(int),NULL,NULL);

//step 5:set kernel arguments
clSetKernelArg(kernel,0,sizeof(cl_mem),&bufferA);
clSetKernelArg(kernel,1,sizeof(cl_mem),&bufferB);
clSetKernelArg(kernel,2,sizeof(cl_mem),&bufferC);

//step 6: enqueue kernel for execution and measure time

size_t globalSize=N;
//clEnqueueNDRangeKernel(queue,kernel,1,NULL,&globalSize,NULL,0,NULL,&event);
err=clEnqueueNDRangeKernel(queue,kernel,1,NULL,&globalSize,NULL,0,NULL,&event);

if(err != CL_SUCCESS){
  
  //HANDLE THE ERROR HERE,EX..,print an error masg and  execution

  printf("error enqueueing kernel:%d\n",err);
  return 1;
}

clWaitEvents(1,&event);

//get kernel exevcution time
cl_ulong startTime,endTime;
clGetEventProfilingInfo(event,CL_PROFILING_COMMAND_START,sizeof(cl_ulong),&startTime,NULL);
clGetEventProfilingInfo(event,CL_PROFILING_COMMAND_END,sizeof(cl_ulong),&endTime,NULL);

double executionTime=(double)(endTime - startTime) / 1000000.0;//convert nanosecond to miliseconds

//step 7: reasd the result from device

clEnqueueReadBuffer(queue,bufferC,CL_TRUE,0,sizeof(int),c,0,NULL,NULL);

//STEP 8: PRINT THE RESULT AND EXECUTION time

printf("execution time :%.6f miliseconds\n",executionTime);
printf("result: ");
printf("%d",*C);
printf("\n");

//step  9: realese resourcess
clReleaseMemObject(bufferA);
clReleaseMemObject(bufferB);
clReleaseMemObject(bufferC);
clReleaseMemObject(kernel);
clReleaseMemObject(program);
clReleaseMemObject(queue);
clReleaseMemObject(context);

//free allocated memory
free(a);
free(b);
free(c);

return 0;

}