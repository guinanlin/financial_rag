<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { AlertCircle, ArrowRight, Eye, EyeOff, Lock, User } from 'lucide-vue-next'

const router = useRouter()
const authStore = useAuthStore()

const identifier = ref('')
const password = ref('')
const error = ref('')
const isLoading = ref(false)
const showPassword = ref(false)

function getFriendlyLoginError(err: any): string {
  const detail = err?.response?.data?.detail
  if (typeof detail === 'string') return detail
  if (err?.response?.status === 401) return '账号或密码不正确，请重新输入'
  return err?.message ? `登录失败：${err.message}` : '登录失败，请检查账号和密码'
}

async function handleLogin() {
  const loginIdentifier = identifier.value.trim()

  if (!loginIdentifier) {
    error.value = '请填写用户名或邮箱'
    return
  }

  if (!password.value) {
    error.value = '请填写密码'
    return
  }

  try {
    isLoading.value = true
    error.value = ''
    await authStore.login(loginIdentifier, password.value)
    router.push('/')
  } catch (err: any) {
    error.value = getFriendlyLoginError(err)
  } finally {
    isLoading.value = false
  }
}
</script>

<template>
  <div class="min-h-screen bg-slate-50 flex items-center justify-center px-4 py-8">
    <div class="w-full max-w-md">
      <!-- Logo -->
      <div class="text-center mb-8">
        <div class="inline-flex items-center justify-center w-12 h-12 rounded-lg bg-emerald-600 text-white mb-4">
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M12 2L2 7l10 5 10-5-10-5z"/>
            <path d="M2 17l10 5 10-5"/>
            <path d="M2 12l10 5 10-5"/>
          </svg>
        </div>
        <h1 class="text-xl font-semibold text-slate-900">企业财税智能平台</h1>
        <p class="text-sm text-slate-500 mt-1">登录您的账号</p>
      </div>

      <!-- Error Message -->
      <div v-if="error" class="mb-4 flex items-center gap-2 rounded-lg bg-red-50 border border-red-200 px-4 py-3 text-sm text-red-700">
        <AlertCircle :size="16" class="shrink-0" />
        <p>{{ error }}</p>
      </div>

      <!-- Login Form -->
      <div class="bg-white rounded-xl border border-slate-200 p-6 shadow-sm">
        <div class="space-y-4">
          <div>
            <label class="block text-sm font-medium text-slate-700 mb-1.5">用户名或邮箱</label>
            <div class="relative">
              <User :size="16" class="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" />
              <input
                v-model="identifier"
                type="text"
                placeholder="请输入用户名或邮箱"
                class="w-full rounded-lg border border-slate-300 bg-white py-2.5 pl-10 pr-4 text-sm text-slate-900 placeholder:text-slate-400 focus:border-emerald-500 focus:outline-none focus:ring-2 focus:ring-emerald-500/20 transition"
                @keydown.enter="handleLogin"
              />
            </div>
          </div>

          <div>
            <label class="block text-sm font-medium text-slate-700 mb-1.5">密码</label>
            <div class="relative">
              <Lock :size="16" class="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" />
              <input
                v-model="password"
                :type="showPassword ? 'text' : 'password'"
                placeholder="请输入密码"
                class="w-full rounded-lg border border-slate-300 bg-white py-2.5 pl-10 pr-10 text-sm text-slate-900 placeholder:text-slate-400 focus:border-emerald-500 focus:outline-none focus:ring-2 focus:ring-emerald-500/20 transition"
                @keydown.enter="handleLogin"
              />
              <button
                type="button"
                @click="showPassword = !showPassword"
                class="absolute right-3 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600 transition"
                aria-label="切换密码显示"
              >
                <Eye v-if="!showPassword" :size="16" />
                <EyeOff v-else :size="16" />
              </button>
            </div>
          </div>
        </div>

        <button
          type="button"
          @click="handleLogin"
          :disabled="isLoading"
          class="mt-6 w-full flex items-center justify-center gap-2 rounded-lg bg-emerald-600 px-4 py-2.5 text-sm font-medium text-white hover:bg-emerald-700 focus:outline-none focus:ring-2 focus:ring-emerald-500/20 transition disabled:opacity-60 disabled:cursor-not-allowed"
        >
          <span>{{ isLoading ? '登录中...' : '登录' }}</span>
          <ArrowRight v-if="!isLoading" :size="16" />
        </button>
      </div>

      <!-- Register Link -->
      <p class="mt-6 text-center text-sm text-slate-500">
        还没有账号？
        <router-link to="/register" class="font-medium text-emerald-600 hover:text-emerald-700 transition">
          立即注册
        </router-link>
      </p>
    </div>
  </div>
</template>
