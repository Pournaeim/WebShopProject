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
    using System.Collections.Generic;
    
    public partial class ViewProduct
    {
        public string CategoryName { get; set; }
        public int Id { get; set; }
        public int CategoryId { get; set; }
        public bool IsPackage { get; set; }
        public string Name { get; set; }
        public int QuantityUnitId { get; set; }
        public string Description { get; set; }
        public System.DateTime Date { get; set; }
        public Nullable<System.DateTime> ProductionDate { get; set; }
        public Nullable<System.DateTime> ExpiryDate { get; set; }
        public Nullable<short> OccasionId { get; set; }
        public string QuantityUnitName { get; set; }
        public Nullable<int> QuantityDetail { get; set; }
        public bool IsDefault { get; set; }
    }
}
