/*

Cleaning Data in SQL Queries

*/


Select * 
From NashvilleHousingData

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

Update NashvilleHousingData
SET SaleDate = CONVERT(Date,SaleDate)

Select SaleDate, CONVERT(Date,SaleDate) AS SaleDateConverted
From NashvilleHousingData

-- If it doesn't Update properly

ALTER TABLE NashvilleHousingData 
Add SaleDateConverted Date;

Update NashvilleHousingData1
SET SaleDateConverted = CONVERT(Date,SaleDate)

Select SaleDateConverted
From NashvilleHousingData
 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From NashvilleHousingData
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousingData a
JOIN NashvilleHousingData b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousingData a
JOIN NashvilleHousingData b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

	--PropertyAddress

Select PropertyAddress
From NashvilleHousingData
--Where PropertyAddress is null

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
From NashvilleHousingData

--#1
ALTER TABLE NashvilleHousingData
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousingData
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

--#2
ALTER TABLE NashvilleHousingData
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousingData
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


Select *
From NashvilleHousingData


	--OwnerAddress

Select OwnerAddress
From NashvilleHousingData


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From NashvilleHousingData

--#1
ALTER TABLE NashvilleHousingData
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousingData
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

--#2
ALTER TABLE NashvilleHousingData
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousingData
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

--#3
ALTER TABLE NashvilleHousingData
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousingData
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


Select *
From NashvilleHousingData


--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From NashvilleHousingData
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From NashvilleHousingData

Update NashvilleHousingData
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
	   
Select SoldAsVacant 
From NashvilleHousingData

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From NashvilleHousingData
--order by ParcelID
)
DELETE
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From NashvilleHousingData

ALTER TABLE NashvilleHousingData
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate



-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------



















