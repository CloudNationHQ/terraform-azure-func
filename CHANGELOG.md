# Changelog

## [1.5.0](https://github.com/CloudNationHQ/terraform-azure-func/compare/v1.4.0...v1.5.0) (2025-03-14)


### Features

* add missing properties and code blocks ([#39](https://github.com/CloudNationHQ/terraform-azure-func/issues/39)) ([eb887be](https://github.com/CloudNationHQ/terraform-azure-func/commit/eb887be26eceebc78f4b5036395a308eecc2a7a2))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#37](https://github.com/CloudNationHQ/terraform-azure-func/issues/37)) ([efc7def](https://github.com/CloudNationHQ/terraform-azure-func/commit/efc7def0b95dbe79a66d1b7d836274d9baab9448))
* **deps:** bump golang.org/x/net from 0.33.0 to 0.36.0 in /tests ([#38](https://github.com/CloudNationHQ/terraform-azure-func/issues/38)) ([3d1fa01](https://github.com/CloudNationHQ/terraform-azure-func/commit/3d1fa0175cec2cfaed1905b6d1fce2c1ef43c14b))

## [1.4.0](https://github.com/CloudNationHQ/terraform-azure-func/compare/v1.3.0...v1.4.0) (2025-01-21)


### Features

* **deps:** bump golang.org/x/net from 0.31.0 to 0.33.0 in /tests ([#34](https://github.com/CloudNationHQ/terraform-azure-func/issues/34)) ([9cc5778](https://github.com/CloudNationHQ/terraform-azure-func/commit/9cc5778e5615508ad2774c08531e3a39d96dac0c))

## [1.3.0](https://github.com/CloudNationHQ/terraform-azure-func/compare/v1.2.0...v1.3.0) (2025-01-08)


### Features

* add several missing properties in linux, windows function apps and slots, and incremented all module usage versions to the latest ([#29](https://github.com/CloudNationHQ/terraform-azure-func/issues/29)) ([13ec48a](https://github.com/CloudNationHQ/terraform-azure-func/commit/13ec48ae07080c96744a0284d94c96a44cf04a9c))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#28](https://github.com/CloudNationHQ/terraform-azure-func/issues/28)) ([352236e](https://github.com/CloudNationHQ/terraform-azure-func/commit/352236ee02ce018b9a352803c015d7acb1831eda))
* **deps:** bump golang.org/x/crypto from 0.29.0 to 0.31.0 in /tests ([#31](https://github.com/CloudNationHQ/terraform-azure-func/issues/31)) ([045dbcb](https://github.com/CloudNationHQ/terraform-azure-func/commit/045dbcb64a3457417c944698e09966dc321cb79e))
* remove redundant submodule service plan ([#33](https://github.com/CloudNationHQ/terraform-azure-func/issues/33)) ([77f2252](https://github.com/CloudNationHQ/terraform-azure-func/commit/77f2252b79ba914ff4b9daf882570750e67a71e9))


### Bug Fixes

* remove temporary files when deployment tests fails ([#32](https://github.com/CloudNationHQ/terraform-azure-func/issues/32)) ([ad37aee](https://github.com/CloudNationHQ/terraform-azure-func/commit/ad37aee0c5ce0e8172d67b372e9ad0f956e0543c))

## [1.2.0](https://github.com/CloudNationHQ/terraform-azure-func/compare/v1.1.0...v1.2.0) (2024-11-11)


### Features

* enhance testing with sequential, parallel modes and flags for exceptions and skip-destroy ([#25](https://github.com/CloudNationHQ/terraform-azure-func/issues/25)) ([5d8b1d2](https://github.com/CloudNationHQ/terraform-azure-func/commit/5d8b1d22c6acf771b96bdeb87904204b11879094))

## [1.1.0](https://github.com/CloudNationHQ/terraform-azure-func/compare/v1.0.0...v1.1.0) (2024-10-11)


### Features

* auto generated docs and refine makefile ([#23](https://github.com/CloudNationHQ/terraform-azure-func/issues/23)) ([8ff836b](https://github.com/CloudNationHQ/terraform-azure-func/commit/8ff836b724b86db44623ca95338de03ed46607c4))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#22](https://github.com/CloudNationHQ/terraform-azure-func/issues/22)) ([d5d0ba2](https://github.com/CloudNationHQ/terraform-azure-func/commit/d5d0ba225c828358d7a7dd83d5aaf2857076328b))

## [1.0.0](https://github.com/CloudNationHQ/terraform-azure-func/compare/v0.5.0...v1.0.0) (2024-09-24)


### ⚠ BREAKING CHANGES

* Version 4 of the azurerm provider includes breaking changes.

### Features

* upgrade azurerm provider to v4 ([#20](https://github.com/CloudNationHQ/terraform-azure-func/issues/20)) ([e79bc5d](https://github.com/CloudNationHQ/terraform-azure-func/commit/e79bc5de0e5e07cab986c81174bc11b90a353f0a))

### Upgrade from v0.5.0 to v1.0.0:

- Update module reference to: `version = "~> 1.0"`
- Rename properties in instance object:
  - resourcegroup -> resource_group
- Rename variable (optional):
  - resourcegroup -> resource_group

## [0.5.0](https://github.com/CloudNationHQ/terraform-azure-func/compare/v0.4.0...v0.5.0) (2024-08-28)


### Features

* update documentation ([#17](https://github.com/CloudNationHQ/terraform-azure-func/issues/17)) ([d093c1b](https://github.com/CloudNationHQ/terraform-azure-func/commit/d093c1bf1c786fc4f55cb80d4be1206ab069a42a))

## [0.4.0](https://github.com/CloudNationHQ/terraform-azure-func/compare/v0.3.0...v0.4.0) (2024-08-28)


### Features

* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#16](https://github.com/CloudNationHQ/terraform-azure-func/issues/16)) ([983b783](https://github.com/CloudNationHQ/terraform-azure-func/commit/983b783ad6435386db486b322810972c1b7b60de))
* update contribution docs ([#14](https://github.com/CloudNationHQ/terraform-azure-func/issues/14)) ([12ef1cc](https://github.com/CloudNationHQ/terraform-azure-func/commit/12ef1ccaa292369e4c318bc9033ad03c20377817))

## [0.3.0](https://github.com/CloudNationHQ/terraform-azure-func/compare/v0.2.0...v0.3.0) (2024-07-02)


### Features

* add issue template ([#12](https://github.com/CloudNationHQ/terraform-azure-func/issues/12)) ([2b2d221](https://github.com/CloudNationHQ/terraform-azure-func/commit/2b2d221f0a4f2cf6154f46f72931015b1da0ed6a))
* create pull request template ([#9](https://github.com/CloudNationHQ/terraform-azure-func/issues/9)) ([6489964](https://github.com/CloudNationHQ/terraform-azure-func/commit/64899641380a68082b77c987df06d6480dcaec66))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#13](https://github.com/CloudNationHQ/terraform-azure-func/issues/13)) ([bc49487](https://github.com/CloudNationHQ/terraform-azure-func/commit/bc4948782fad23e7d1c0d93018246941afaeb788))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#8](https://github.com/CloudNationHQ/terraform-azure-func/issues/8)) ([e3fef9f](https://github.com/CloudNationHQ/terraform-azure-func/commit/e3fef9f84607f18157d02ebf73fe181e2d4aa1c3))
* **deps:** bump github.com/hashicorp/go-getter in /tests ([#11](https://github.com/CloudNationHQ/terraform-azure-func/issues/11)) ([6f638d0](https://github.com/CloudNationHQ/terraform-azure-func/commit/6f638d0240ce93cdec4a6baf30b58158bf06fec9))

## [0.2.0](https://github.com/CloudNationHQ/terraform-azure-func/compare/v0.1.0...v0.2.0) (2024-05-15)


### Features

* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#6](https://github.com/CloudNationHQ/terraform-azure-func/issues/6)) ([fe43bd1](https://github.com/CloudNationHQ/terraform-azure-func/commit/fe43bd16125b30b77aa5f6bec8763896ad01c64c))
* **deps:** bump github.com/hashicorp/go-getter in /tests ([#5](https://github.com/CloudNationHQ/terraform-azure-func/issues/5)) ([62d0997](https://github.com/CloudNationHQ/terraform-azure-func/commit/62d0997658515023fb56bb376fffd2d032f43975))
* **deps:** bump golang.org/x/net from 0.17.0 to 0.23.0 in /tests ([#4](https://github.com/CloudNationHQ/terraform-azure-func/issues/4)) ([2a373c9](https://github.com/CloudNationHQ/terraform-azure-func/commit/2a373c9e5c7e9d44c7a977b9935d0f4c800790a4))

## 0.1.0 (2024-05-15)


### Features

* add initial resources ([#2](https://github.com/CloudNationHQ/terraform-azure-func/issues/2)) ([9ee6b32](https://github.com/CloudNationHQ/terraform-azure-func/commit/9ee6b32b5f622b00e7be3dd29de5688a2124048a))
