/*

Cleaning Data in SQL Queries

*/

select*
from portfoilioproject.dbo.NashvilleHouseing


--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

select SaleDateConverted, CONVERT(date,SaleDate)
from portfoilioproject.dbo.NashvilleHouseing


update portfoilioproject.dbo.NashvilleHouseing
set SaleDate = CONVERT(date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE portfoilioproject.dbo.NashvilleHouseing
Add SaleDateConverted Date;



Update portfoilioproject.dbo.NashvilleHouseing
SET SaleDateConverted = CONVERT(Date,SaleDate)

 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

select *
from portfoilioproject.dbo.NashvilleHouseing
---where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From portfoilioproject.dbo.NashvilleHouseing a
JOIN portfoilioproject.dbo.NashvilleHouseing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From portfoilioproject.dbo.NashvilleHouseing a
JOIN portfoilioproject.dbo.NashvilleHouseing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


select PropertyAddress
from portfoilioproject.dbo.NashvilleHouseing
---where PropertyAddress is null
order by ParcelID

select
substring (PropertyAddress, 1 , CHARINDEX(',',PropertyAddress) - 1) as Address,
substring (PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, len(PropertyAddress)) as Address

from portfoilioproject.dbo.NashvilleHouseing



ALTER TABLE portfoilioproject.dbo.NashvilleHouseing
Add PropertySplitAddress nvarchar(255);



Update portfoilioproject.dbo.NashvilleHouseing
SET propertySplitAddress = substring (PropertyAddress, 1 , CHARINDEX(',',PropertyAddress) - 1)


ALTER TABLE portfoilioproject.dbo.NashvilleHouseing
Add PropertySplitcity nvarchar(255);

Update portfoilioproject.dbo.NashvilleHouseing
SET propertySplitcity = substring (PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, len(PropertyAddress))


select *
from portfoilioproject.dbo.NashvilleHouseing


select OwnerAddress
from portfoilioproject.dbo.NashvilleHouseing


select
PARSENAME (replace(OwnerAddress, ',', '.'), 3),
PARSENAME (replace(OwnerAddress, ',', '.'), 2),
PARSENAME (replace(OwnerAddress, ',', '.'), 1)
from portfoilioproject.dbo.NashvilleHouseing


ALTER TABLE portfoilioproject.dbo.NashvilleHouseing
Add OwnerSplitAddress nvarchar(255);



Update portfoilioproject.dbo.NashvilleHouseing
SET OwnerSplitAddress = PARSENAME (replace(OwnerAddress, ',', '.'), 3)


ALTER TABLE portfoilioproject.dbo.NashvilleHouseing
Add OwnerSplitcity nvarchar(255);

Update portfoilioproject.dbo.NashvilleHouseing
SET OwnerSplitcity = PARSENAME (replace(OwnerAddress, ',', '.'), 2)


ALTER TABLE portfoilioproject.dbo.NashvilleHouseing
Add OwnerSplitState nvarchar(255);

Update portfoilioproject.dbo.NashvilleHouseing
SET OwnerSplitState = PARSENAME (replace(OwnerAddress, ',', '.'), 1)

select *
from portfoilioproject.dbo.NashvilleHouseing



--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


select distinct(SoldAsVacant), count(SoldAsVacant)
from portfoilioproject.dbo.NashvilleHouseing
group by SoldAsVacant
order by 2

select SoldAsVacant,
case when SoldAsVacant = 'Y' Then 'Yes'
     when SoldAsVacant = 'N' Then 'No'
	 else SoldAsVacant
	 End
from portfoilioproject.dbo.NashvilleHouseing

update portfoilioproject.dbo.NashvilleHouseing
set SoldAsVacant = case when SoldAsVacant = 'Y' Then 'Yes'
     when SoldAsVacant = 'N' Then 'No'
	 else SoldAsVacant
	 End


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
					) as row_num

From portfoilioproject.dbo.NashvilleHouseing
--order by ParcelID
)
select *
From RowNumCTE
where row_num >1
order by PropertyAddress



Select *
From portfoilioproject.dbo.NashvilleHouseing




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From portfoilioproject.dbo.NashvilleHouseing

ALTER TABLE portfoilioproject.dbo.NashvilleHouseing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate