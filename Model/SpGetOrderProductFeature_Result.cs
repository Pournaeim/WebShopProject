//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Model
{
    using System;
    
    public partial class SpGetOrderProductFeature_Result
    {
        public System.Guid Id { get; set; }
        public Nullable<System.Guid> ParentId { get; set; }
        public int ProductId { get; set; }
        public Nullable<int> FeatureTypeDetailId { get; set; }
        public string FeatureTypeDetailName { get; set; }
        public string FeatureTypeName { get; set; }
        public Nullable<decimal> Price { get; set; }
        public Nullable<int> Quantity { get; set; }
        public int FeatureTypeId { get; set; }
        public int Priority { get; set; }
        public int FeatureTypePriority { get; set; }
        public int FeatureTypeDetailPriority { get; set; }
        public string IconUrl { get; set; }
        public string ImageTitle { get; set; }
        public string ImageUrl { get; set; }
        public int ImagePriority { get; set; }
        public string LinkUrl { get; set; }
        public Nullable<bool> Showcase { get; set; }
        public Nullable<System.DateTime> ProductionDate { get; set; }
        public Nullable<System.DateTime> ExpiryDate { get; set; }
        public string ProductName { get; set; }
        public int CategoryId { get; set; }
        public string ProductDescription { get; set; }
        public string Description { get; set; }
        public string CategoryName { get; set; }
        public int BaseFeatureTypeDetailId { get; set; }
    }
}
