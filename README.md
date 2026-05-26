# WRF in a Docker

This project aims to provide a controlled environment for running test simulations on WRF and provide a learning platform for WRF alonside with the tools that are required to visualize the output data.

Ubuntu 24.04 LTS, WRF version 4.6.1 and WPS 4.6.0 used.

## Usage

- **On UNIX-like systems and WSL:**
  ```sh
  bash -c "$(curl -sSL https://raw.githubusercontent.com/itu-metsen/wrf_docker/master/scripts/wrf_docker.sh)"
  ```
  At the installation pipe folder location between the os and the container will be asked. Default path is `$USR/Documents/wrf_docker`.
  
  On WSL you will be need to navigate to there for file transfer between the container and the os.
  
  The Windows native script has not yet been tested, use it at your own risk.
  
- **After container has been built:**
  - `docker start wrf` For starting, stopped container.
  - `docker stop wrf` For stopping, running container.


## Prerequisites

- [Docker](https://www.docker.com/get-started) installation.
- WSL installation if running on Windows.

## Features
- WRF installation script.
- Conda environment for visualizations, `conda activate pywrf`.
- Pipe for fast file transfer between the os and the container.

## Directory Structure

- `/scripts` – Scripts for building, installing, and running WRF
- `Dockerfile` – Instructions to build the standard environment

## Contributing

Contributions are welcome! If you find issues or have enhancements, please open an issue or submit a pull request.

## License

This project is open-source and available under the [Apache License 2.0 License](LICENSE).

## Contact

For questions or support, please open an issue or contact the maintainer.


## Acknowledgments & Credits

* The WRF installation process in this project utilizes the `WRF4.6.1_Install.bash` script originally authored by [Umur Dinç](https://github.com/bakamotokatas). You can find the original script and repository here: [WRF-Install-Script](https://github.com/bakamotokatas/WRF-Install-Script). The script has been slightly modified to be fully compatible with our containerized Docker environment.
