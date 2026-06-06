#include <libopencm3/stm32/rcc.h>
#include <libopencm3/stm32/gpio.h>
#include <stdint.h>

static const uint8_t sine_table[256] = {
    128,131,134,137,140,143,146,149,152,155,158,162,165,167,170,173,
    176,179,182,185,188,190,193,196,198,201,203,206,208,211,213,215,
    218,220,222,224,226,228,230,232,234,235,237,238,240,241,242,244,
    245,246,247,248,249,250,250,251,252,252,253,253,253,254,254,254,
    254,254,254,254,253,253,253,252,252,251,250,250,249,248,247,246,
    245,244,242,241,240,238,237,235,234,232,230,228,226,224,222,220,
    218,215,213,211,208,206,203,201,198,196,193,190,188,185,182,179,
    176,173,170,167,165,162,158,155,152,149,146,143,140,137,134,131,
    128,124,121,118,115,112,109,106,103,100, 97, 93, 90, 88, 85, 82,
     79, 76, 73, 70, 67, 65, 62, 59, 57, 54, 52, 49, 47, 44, 42, 40,
     37, 35, 33, 31, 29, 27, 25, 23, 21, 20, 18, 17, 15, 14, 13, 11,
     10,  9,  8,  7,  6,  5,  5,  4,  3,  3,  2,  2,  2,  1,  1,  1,
      1,  1,  1,  1,  2,  2,  2,  3,  3,  4,  5,  5,  6,  7,  8,  9,
     10, 11, 13, 14, 15, 17, 18, 20, 21, 23, 25, 27, 29, 31, 33, 35,
     37, 40, 42, 44, 47, 49, 52, 54, 57, 59, 62, 65, 67, 70, 73, 76,
     79, 82, 85, 88, 90, 93, 97,100,103,106,109,112,115,118,121,124
};

static void clock_setup(void)
{
    rcc_clock_setup_in_hse_8mhz_out_72mhz();
}

static void gpio_setup(void)
{
    rcc_periph_clock_enable(RCC_GPIOA);

    gpio_set_mode(GPIOA,
                  GPIO_MODE_OUTPUT_50_MHZ,
                  GPIO_CNF_OUTPUT_PUSHPULL,
                  GPIO0 | GPIO1 | GPIO2 | GPIO3 |
                  GPIO4 | GPIO5 | GPIO6 | GPIO7);
}

static void delay_us(uint32_t us)
{
    for (uint32_t i = 0; i < us * 18; i++) {
        __asm__("nop");
    }
}

static inline void dac_write(uint8_t value)
{
    uint32_t port = GPIO_ODR(GPIOA);
    port = (port & 0xFFFFFF00) | value;
    GPIO_ODR(GPIOA) = port;
}

int main(void)
{
    clock_setup();
    gpio_setup();

    uint8_t index = 0;

    while (1) {
        dac_write(sine_table[index]);
        index++;
        delay_us(39);
    }

    return 0;
}
