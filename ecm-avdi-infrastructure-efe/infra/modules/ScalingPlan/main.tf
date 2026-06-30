# This module creates Scaling Plans in Azure Virtual Desktop which can be used to automatically scale host pools based on user-defined schedules and rules.
terraform {
  required_providers {
    azapi = {
      source = "Azure/azapi"
    }
  }
}
resource "azapi_resource" "scalingPlan" {
  for_each = var.scalingPlanVariables
 
  type      = "Microsoft.DesktopVirtualization/scalingPlans@2024-04-03"
  name      = each.value.name
  parent_id = var.resource_group_ids[each.value.resource_group_key]
  location  = each.value.location
 
  body = {
    properties = {
      friendlyName = try(each.value.friendly_name, null)
      description  = try(each.value.description, null)
      timeZone     = each.value.time_zone
      exclusionTag = try(each.value.exclusion_tag, null)
      hostPoolType = each.value.hostPoolType

      hostPoolReferences = [
        {
          hostPoolArmPath    = var.hostpool_ids[each.value.hostpool_key]
          scalingPlanEnabled = try(each.value.enabled, true)
        }
      ]
    }
  }
 
  tags =  try(each.value.tags, {})
  lifecycle {
     prevent_destroy = true
  }
}
 
resource "azapi_resource" "personalSchedule" {
  for_each = merge([
    for sp_key, sp in var.scalingPlanVariables : {
      for sched in sp.personal_schedules :
      "${sp_key}-${sched.name}" => {
        scaling_plan_key = sp_key
        schedule         = sched
      }
    }
  ]...)
 
  type      = "Microsoft.DesktopVirtualization/scalingPlans/personalSchedules@2024-04-03"
  name      = each.value.schedule.name
  parent_id = azapi_resource.scalingPlan[each.value.scaling_plan_key].id
 
  body = {
    properties = {
      daysOfWeek = each.value.schedule.days_of_week
 
      rampUpStartTime = {
        hour   = tonumber(split(":", each.value.schedule.ramp_up_start_time)[0])
        minute = tonumber(split(":", each.value.schedule.ramp_up_start_time)[1])
      }
      rampUpAutoStartHosts            = each.value.schedule.ramp_up_auto_start_hosts
      rampUpStartVMOnConnect          = each.value.schedule.ramp_up_start_vm_on_connect
      rampUpActionOnDisconnect        = each.value.schedule.ramp_up_action_on_disconnect
      rampUpMinutesToWaitOnDisconnect = each.value.schedule.ramp_up_minutes_to_wait_on_disconnect
      rampUpActionOnLogoff            = each.value.schedule.ramp_up_action_on_logoff
      rampUpMinutesToWaitOnLogoff     = each.value.schedule.ramp_up_minutes_to_wait_on_logoff
 
      peakStartTime = {
        hour   = tonumber(split(":", each.value.schedule.peak_start_time)[0])
        minute = tonumber(split(":", each.value.schedule.peak_start_time)[1])
      }
      peakStartVMOnConnect          = each.value.schedule.peak_start_vm_on_connect
      peakActionOnDisconnect        = each.value.schedule.peak_action_on_disconnect
      peakMinutesToWaitOnDisconnect = each.value.schedule.peak_minutes_to_wait_on_disconnect
      peakActionOnLogoff            = each.value.schedule.peak_action_on_logoff
      peakMinutesToWaitOnLogoff     = each.value.schedule.peak_minutes_to_wait_on_logoff
 
      rampDownStartTime = {
        hour   = tonumber(split(":", each.value.schedule.ramp_down_start_time)[0])
        minute = tonumber(split(":", each.value.schedule.ramp_down_start_time)[1])
      }
      rampDownStartVMOnConnect          = each.value.schedule.ramp_down_start_vm_on_connect
      rampDownActionOnDisconnect        = each.value.schedule.ramp_down_action_on_disconnect
      rampDownMinutesToWaitOnDisconnect = each.value.schedule.ramp_down_minutes_to_wait_on_disconnect
      rampDownActionOnLogoff            = each.value.schedule.ramp_down_action_on_logoff
      rampDownMinutesToWaitOnLogoff     = each.value.schedule.ramp_down_minutes_to_wait_on_logoff
 
      offPeakStartTime = {
        hour   = tonumber(split(":", each.value.schedule.off_peak_start_time)[0])
        minute = tonumber(split(":", each.value.schedule.off_peak_start_time)[1])
      }
      offPeakStartVMOnConnect          = each.value.schedule.off_peak_start_vm_on_connect
      offPeakActionOnDisconnect        = each.value.schedule.off_peak_action_on_disconnect
      offPeakMinutesToWaitOnDisconnect = each.value.schedule.off_peak_minutes_to_wait_on_disconnect
      offPeakActionOnLogoff            = each.value.schedule.off_peak_action_on_logoff
      offPeakMinutesToWaitOnLogoff     = each.value.schedule.off_peak_minutes_to_wait_on_logoff
    }
  }
 
  depends_on = [
    azapi_resource.scalingPlan
  ]
    lifecycle {
     prevent_destroy = true
  }
}
