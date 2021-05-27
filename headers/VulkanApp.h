#include "glm/fwd.hpp"
#include <vulkan/vulkan_core.h>
#define GLFW_INCLUDE_VULKAN
#include <GLFW/glfw3.h>

#define GLM_FORCE_RADIANS
#include <glm/glm.hpp>
#include <glm/ext.hpp>

#include <assert.h>
#include <chrono>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <optional>
#include <set>
#include <stdexcept>
#include <stdint.h>
#include <string>
#include <vector>

struct QueueFamilyIndices
{
    std::optional<uint32_t> graphicsFamily;
    std::optional<uint32_t> presentFamily;

    bool isComplete() { return graphicsFamily.has_value() && presentFamily.has_value(); }
};

struct SwapChainSupportDetails
{
    VkSurfaceCapabilitiesKHR capabilities;
    std::vector<VkSurfaceFormatKHR> formats;
    std::vector<VkPresentModeKHR> presentModes;
};

struct UniformBufferObject
{
    glm::vec4 mandelbrotValues;
};

class VulkanApp
{
public:
    void run();

    bool frameBufferResized = false;

    // Mandelbrot controls
    void scrollUp();
    void scrollLeft();
    void scrollDown();
    void scrollRight();

    void zoomIn();
    void zoomOut();

    glm::vec3 mandelbrotVals;

private:
    // Main app funcs
    void initWindow();
    void initVulkan();
    void mainLoop();
    void drawFrame();
    void cleanup();

    // Handle window resize
    void cleanupSwapChain();
    void recreateSwapChain();

    // Vulkan specific funcs
    void createInstance();
    std::vector<const char*> getRequiredExtensions();
    bool checkValidationLayerSupport();
    void pickPhysicalDevice();
    bool isDeviceSuitable(VkPhysicalDevice device);
    bool checkDeviceExtensionSupport(VkPhysicalDevice device);
    QueueFamilyIndices findQueueFamilies(VkPhysicalDevice device);
    void createLogicalDevice();
    void createSurface();
    SwapChainSupportDetails querySwapChainSupport(VkPhysicalDevice device);
    VkSurfaceFormatKHR chooseSwapSurfaceFormat(const std::vector<VkSurfaceFormatKHR>& availableFormats);
    VkPresentModeKHR chooseSwapPresentMode(const std::vector<VkPresentModeKHR>& availablePresentModes);
    VkExtent2D chooseSwapExtent(const VkSurfaceCapabilitiesKHR& capabilities);
    void createSwapChain();
    void createImageViews();
    void createDescriptorSetLayout();
    void createGraphicsPipeline();
    VkShaderModule createShaderModule(const std::vector<char>& bytecode);
    void createRenderPass();
    void createFramebuffers();
    void createCommandPool();
    void createCommandBuffers();
    void createSyncObjs();
    uint32_t findMemoryType(uint32_t typeFilter, VkMemoryPropertyFlags properties);
    void createBuffer(VkDeviceSize size,
            VkBufferUsageFlags usage,
            VkMemoryPropertyFlags properties,
            VkBuffer& buffer,
            VkDeviceMemory& bufferMemory);
    void createUniformBuffers();
    void updateUniformBuffer(uint32_t currentImage);
    void createDescriptorPool();
    void createDescriptorSets();

    void setupDebugMessenger();
    void populateDebugMessagerCreateInfo(VkDebugUtilsMessengerCreateInfoEXT& createInfo);

    GLFWwindow* window = nullptr;
    VkInstance instance;
    VkDebugUtilsMessengerEXT debugMessenger;
    VkPhysicalDevice physicalDevice = VK_NULL_HANDLE;

    VkDevice device;
    VkQueue graphicsQueue;
    VkQueue presentQueue;
    VkSurfaceKHR surface;

    VkSwapchainKHR swapChain;
    std::vector<VkImage> swapChainImages;
    VkFormat swapChainImageFormat;
    VkExtent2D swapChainExtent;
    std::vector<VkImageView> swapChainImageViews;
    VkRenderPass renderPass;
    VkDescriptorSetLayout descriptorSetLayout;
    VkPipelineLayout pipelineLayout;
    VkPipeline graphicsPipeline;
    std::vector<VkFramebuffer> swapChainFramebuffers;

    VkCommandPool commandPool;
    std::vector<VkCommandBuffer> commandBuffers;
    std::vector<VkSemaphore> imageAvailableSemaphores;
    std::vector<VkSemaphore> renderFinishedSemaphores;
    std::vector<VkFence> inFlightFences;
    std::vector<VkFence> imagesInFlight;

    std::vector<VkBuffer> uniformBuffers;
    std::vector<VkDeviceMemory> uniformBuffersMemory;
    VkDescriptorPool descriptorPool;
    std::vector<VkDescriptorSet> descriptorSets;
    size_t currentFrame = 0;

    const uint32_t WIDTH = 800;
    const uint32_t HEIGHT = 600;
    const int MAX_FRAMES_IN_FLIGHT = 2;

    const std::vector<const char*> validationLayers =
    {
        "VK_LAYER_KHRONOS_validation",
    };

    const std::vector<const char*> deviceExtensions =
    {
        VK_KHR_SWAPCHAIN_EXTENSION_NAME,
    };

#ifdef NDEBUG
    const bool enableValidationLayers = false;
#else
    const bool enableValidationLayers = true;
#endif

};
