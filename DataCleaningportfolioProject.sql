--select *
--from portfolioProject01.dbo.NashvilleHousing

------------------------------------------------------------------------------------------------------------------
--standardize date format

--select saledate, convert(date, saledate)
--from portfolioProject01..NashvilleHousing


--select *
--from portfolioProject01..NashvilleHousing

--Alter Table portfolioProject01..NashvilleHousing
--alter column SaleDate Date;


--alter table portfolioProject01..Nashvillehousing
--add SaleDateConverted date;

--update PortfolioProject01..NashvilleHousing
--set SaleDateConverted = SaleDate


------------------------------------------------------------------------------------------------------
--populate property address data
--select *
--from portfolioProject01..NashvilleHousing
--where PropertyAddress is null

--Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyAddress, b.PropertyAddress)
--from portfolioProject01..NashvilleHousing a
--join portfolioProject01..NashvilleHousing b
--	on a.ParcelID = b.ParcelID
--	and a.[UniqueID ] != b.[UniqueID ]
--where a.PropertyAddress is null

--update a
--set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
--from portfolioProject01..NashvilleHousing a
--join portfolioProject01..NashvilleHousing b
--	on a.ParcelID = b.ParcelID
--	and a.[UniqueID ] != b.[UniqueID ]
--where a.PropertyAddress is null


------------------------------------------------------------------------------------------------------------
--breaking out address into individual columns(address, city, state)
--select PropertyAddress
--from portfolioProject01..NashvilleHousing

--select
--SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as street,
--SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(propertyaddress)) as city
--from portfolioProject01..NashvilleHousing

--alter table portfolioProject01..Nashvillehousing
--add PropertyAddressStreet Nvarchar(255)

--update PortfolioProject01..NashvilleHousing
--set PropertyAddressStreet = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

--alter table portfolioProject01..Nashvillehousing
--add PropertyAddressCity Nvarchar(255)

--update PortfolioProject01..NashvilleHousing
--set PropertyAddressCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(propertyaddress))


--select * 
--from portfolioProject01..NashvilleHousing

--select OwnerAddress
--from portfolioProject01..NashvilleHousing


--select PARSENAME(replace(ownerAddress, ',', '.'), 3),
--PARSENAME(replace(ownerAddress, ',', '.'), 2),
--PARSENAME(replace(ownerAddress, ',', '.'), 1)
--from portfolioProject01..NashvilleHousing
--where OwnerAddress is not null

--alter table portfolioProject01..Nashvillehousing
--add ownerAddressStreet Nvarchar(255)

--update PortfolioProject01..NashvilleHousing
--set ownerAddressStreet = PARSENAME(replace(ownerAddress, ',', '.'), 3)

--alter table portfolioProject01..Nashvillehousing
--add ownerAddressCity Nvarchar(255)

--update PortfolioProject01..NashvilleHousing
--set ownerAddressCity = PARSENAME(replace(ownerAddress, ',', '.'), 2)


--alter table portfolioProject01..Nashvillehousing
--add ownerAddressState Nvarchar(255)

--update PortfolioProject01..NashvilleHousing
--set ownerAddressState = PARSENAME(replace(ownerAddress, ',', '.'), 1)


---------------------------------------------------------------------------------------------

--change Y and N to Yes and No in "sold as vacant" field

--select Distinct(SoldAsVacant), count(SoldAsVacant)
--from PortfolioProject01..NashvilleHousing
--group by SoldAsVacant
--order by 2

--select SoldAsVacant
--,case when SoldAsVacant = 'Y' then 'Yes'
--	when SoldAsVacant = 'N' then 'No'
--	else SoldAsVacant
--	end
--from PortfolioProject01..NashvilleHousing

--update PortfolioProject01..NashvilleHousing
--set SoldAsVacant =case when SoldAsVacant = 'Y' then 'Yes'
--	when SoldAsVacant = 'N' then 'No'
--	else SoldAsVacant
--	end



---------------------------------------------------------------------------------------------------------
--remove duplicates
with duplicateRows as (
select *, ROW_NUMBER() 
	over( partition by ParcelID,
						LandUse,
						PropertyAddress,
						SaleDate,
						SalePrice,
						LegalReference
						order by UniqueID) as row_num

from PortfolioProject01..NashvilleHousing
)
select * 
from duplicateRows
where row_num > 1
order by ParcelID
--should not showing anything, because all duplications are removed.


