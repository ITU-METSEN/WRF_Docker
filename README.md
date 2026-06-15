# WRF in a Docker

  This project aims to provide a controlled environment for running test simulations on WRF and provide a learning platform for WRF alonside with the tools that are required to visualize the output data.

Ubuntu 24.04 LTS, WRF version 4.8.0 and WPS 4.6.0 are used.

## Usage

- **One-liner code for WSL, Linux and MacOS:**
  ```sh
  bash -c "$(curl -sSL https://raw.githubusercontent.com/itu-metsen/wrf_docker/main/scripts/wrf_docker.sh)"
  ```
  At the installation pipe folder location between the os and the container will be asked. Default path is `$USR/Documents/wrf_docker`.
  
  On WSL you will be need to navigate to pipe for file transfer between the container and the os.
    
  After setup:
  - `docker start wrf` for starting the container.
  - `docker stop wrf` for stopping the container.


## Prerequisites

- [Docker](https://www.docker.com/get-started) installation.
- WSL installation if running on Windows.

## Features
- WRF installation script.
- Conda environment for visualizations, `conda activate pywrf`.
- Pipe folder for fast file transfer between the os and the container.

## Directory Structure

- `/scripts` – Scripts for building, installing, and running WRF
- `Dockerfile` – Instructions to build the standard environment
- `/.github/workflows` - Automated image build and push to ghcr.

## Contributing

Contributions are welcome! If you find issues or have enhancements, please open an issue or submit a pull request.

## Contact

For questions or support, please open an issue or contact the maintainer.


## Acknowledgments & Credits

* The WRF installation process in this project utilizes the `WRF4.6.1_Install.bash` script originally authored by [Umur Dinç](https://github.com/bakamotokatas). You can find the original script and repository here: [WRF-Install-Script](https://github.com/bakamotokatas/WRF-Install-Script). The script has been slightly modified to be fully compatible with our containerized Docker environment.
